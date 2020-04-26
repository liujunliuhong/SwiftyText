//
//  SwiftyTextAsyncLayer.m
//  SwiftyText
//
//  Created by apple on 2020/4/26.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import "SwiftyTextAsyncLayer.h"
#import <UIKit/UIKit.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    #include <stdatomic.h>
#else
    #import <libkern/OSAtomic.h>
#endif


@implementation SwiftyTextSentinel{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    atomic_int_fast64_t _atomic_int_fast64_t_Value;
#else
    int64_t _int64_t_value;
#endif
}

- (int64_t)value{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    return _atomic_int_fast64_t_Value;
#else
    return _int64_t_value;
#endif
}

- (int64_t)increase{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    atomic_fetch_add_explicit(&_atomic_int_fast64_t_Value, 1, memory_order_relaxed);
    return _atomic_int_fast64_t_Value;
#else
    return OSAtomicIncrement64(&_int64_t_value);
#endif
}

+ (int64_t)increase:(int64_t *)value{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    atomic_int_fast64_t tmp = *value;
    atomic_fetch_add_explicit(&tmp, 1, memory_order_relaxed);
    return tmp;
#else
    return OSAtomicIncrement64(value);
#endif
}
@end




@implementation SwiftyTextAsyncLayerDisplayTask

@end





/// Global display queue, used for content rendering.
static dispatch_queue_t SwiftyTextAsyncLayerGetDisplayQueue() {
#define MAX_QUEUE_COUNT 16
    static int queueCount;
    static dispatch_queue_t queues[MAX_QUEUE_COUNT];
    static dispatch_once_t onceToken;
    static int64_t counter = 0;
    dispatch_once(&onceToken, ^{
        queueCount = (int)[NSProcessInfo processInfo].activeProcessorCount;
        queueCount = queueCount < 1 ? 1 : queueCount > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : queueCount;
        for (NSUInteger i = 0; i < queueCount; i++) {
            dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
            queues[i] = dispatch_queue_create("com.yinhe.async.queue", attr);
        }
    });
    int64_t cur = [SwiftyTextSentinel increase:&counter];
    if (cur < 0) {
        cur = -cur;
    }
    return queues[(cur) % queueCount];
#undef MAX_QUEUE_COUNT
}


static dispatch_queue_t SwiftyTextAsyncLayerGetReleaseQueue() {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
}


@interface SwiftyTextAsyncLayer()
@property (nonatomic, strong) SwiftyTextSentinel *sentinel;
@end

@implementation SwiftyTextAsyncLayer
- (void)dealloc{
    [self.sentinel increase];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithLayer:(id)layer{
    self = [super initWithLayer:layer];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    self.contentsScale = scale;
    
    self.displaysAsynchronously = YES;
}

- (void)setNeedsDisplay{
    [self cancelAsyncDisplay];
    [super setNeedsDisplay];
}

- (void)display{
    super.contents = super.contents;
    [self displayAsync:self.displaysAsynchronously];
}


#pragma mark Private Methods
/*
 Core code:
 dispatch_async(YHAsyncLayerGetDisplayQueue(), ^{
     UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
     CGContextRef context = UIGraphicsGetCurrentContext();
     task.display(context, size, isCancelled);
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     dispatch_async(dispatch_get_main_queue(), ^{
         self.contents = (__bridge id)(image.CGImage);
     });
 }];
 */
- (void)displayAsync:(BOOL)async {
    
    __strong id<SwiftyTextAsyncLayerDelegate> delegate = (id)self.delegate;
    
    SwiftyTextAsyncLayerDisplayTask *task = [delegate newAsyncDisplayTask];
    
    // When `display` does not exist
    if (!task.display) {
        if (task.willDisplay) {
            task.willDisplay(self);
        }
        self.contents = nil;
        if (task.didDisplay) {
            task.didDisplay(self, YES);
        }
        return;
    }
    
    
    
    if (async) {
        if (task.willDisplay) {
            task.willDisplay(self);
        }
        
        SwiftyTextSentinel *sentinel = self.sentinel;
        int64_t value = sentinel.value;
        BOOL(^isCancelled)(void) = ^BOOL() {
            return value != sentinel.value;
        };
        
        CGSize size = self.bounds.size;
        BOOL opaque = self.opaque;
        CGFloat scale = self.contentsScale;
        CGColorRef backgroundColor = (opaque && self.backgroundColor) ? CGColorRetain(self.backgroundColor) : NULL;
        // If the size is too small
        if (size.width < 1.0 || size.height < 1.0) {
            CGImageRef image = (__bridge_retained CGImageRef)(self.contents);
            self.contents = nil;
            if (image) {
                dispatch_async(SwiftyTextAsyncLayerGetReleaseQueue(), ^{
                    CFRelease(image);
                });
            }
            if (task.didDisplay) {
                task.didDisplay(self, YES); // finished = YES
            }
            CGColorRelease(backgroundColor);
            return;
        }
        
        dispatch_async(SwiftyTextAsyncLayerGetDisplayQueue(), ^{
            if (isCancelled()) {
                CGColorRelease(backgroundColor);
                return;
            }
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            if (opaque && context) {
                CGContextSaveGState(context);
                {
                    if (!backgroundColor || CGColorGetAlpha(backgroundColor) < 1) {
                        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                        CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                        CGContextFillPath(context);
                    }
                    if (backgroundColor) {
                        CGContextSetFillColorWithColor(context, backgroundColor);
                        CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                        CGContextFillPath(context);
                    }
                }
                CGContextRestoreGState(context);
                CGColorRelease(backgroundColor);
            }
            
            if (task.display) {
                task.display(context, size, isCancelled);
            }
            // For the same `SwiftyTextAsyncLayer`, it is likely that when a new drawing request arrives, the current drawing task is not yet completed, and the current drawing task is useless and will continue to consume too much CPU (GPU) resources. Of course, this kind of scene mainly occurs when the list interface scrolls quickly. Due to the multiplexing mechanism of the view, the request for redrawing is very frequent.
            // Therefore, it is necessary to cancel the drawing at the appropriate actual
            if (isCancelled()) {
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplay) {
                        task.didDisplay(self, NO); // finished = NO
                    }
                });
                return;
            }
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext(); // Generate image asynchronously
            UIGraphicsEndImageContext();
            if (isCancelled()) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplay) {
                        task.didDisplay(self, NO); // finished = NO
                    }
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{ // Switch to main thread
                if (isCancelled()) {
                    if (task.didDisplay) {
                        task.didDisplay(self, NO); // finished = NO
                    }
                } else {
                    self.contents = (__bridge id)(image.CGImage);
                    if (task.didDisplay) {
                        task.didDisplay(self, YES); // finished = YES
                    }
                }
            });
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sentinel increase];
            if (task.willDisplay) {
                task.willDisplay(self);
            }
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.contentsScale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            if (self.opaque && context) {
                CGSize size = self.bounds.size;
                size.width *= self.contentsScale;
                size.height *= self.contentsScale;
                CGContextSaveGState(context);
                {
                    if (!self.backgroundColor || CGColorGetAlpha(self.backgroundColor) < 1) {
                        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                        CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
                        CGContextFillPath(context);
                    }
                    if (self.backgroundColor) {
                        CGContextSetFillColorWithColor(context, self.backgroundColor);
                        CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
                        CGContextFillPath(context);
                    }
                }
                CGContextRestoreGState(context);
            }
            
            if (task.display) {
                task.display(context, self.bounds.size, ^{return NO;});
            }
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext(); // Generate image
            UIGraphicsEndImageContext();
            self.contents = (__bridge id)(image.CGImage);
            
            if (task.didDisplay) {
                task.didDisplay(self, YES); // finished = YES
            }
        });
    }
}

- (void)cancelAsyncDisplay{
    [self.sentinel increase];
}

#pragma mark Getter
- (SwiftyTextSentinel *)sentinel{
    if (!_sentinel) {
        _sentinel = [[SwiftyTextSentinel alloc] init];
    }
    return _sentinel;
}
@end
