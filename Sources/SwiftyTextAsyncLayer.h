//
//  SwiftyTextAsyncLayer.h
//  SwiftyText
//
//  Created by apple on 2020/4/26.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

/// Thread-safe counter
/// Inspired by `YYSentinel` of `YYKit`, and made improvements based on this
@interface SwiftyTextSentinel : NSObject
@property (nonatomic, assign, readonly) int64_t value;
- (int64_t)increase;
+ (int64_t)increase:(int64_t *)value;
@end


/// Asynchronous drawing task
@interface SwiftyTextAsyncLayerDisplayTask : NSObject
@property (nullable, nonatomic, copy) void (^willDisplay)(CALayer *_Nullable layer);
@property (nullable, nonatomic, copy) void (^display)(CGContextRef _Nullable context, CGSize size, BOOL(^isCancelled)(void));
@property (nullable, nonatomic, copy) void (^didDisplay)(CALayer *layer, BOOL finished);
@end


/// Asynchronous drawing agent
@protocol SwiftyTextAsyncLayerDelegate <NSObject>
- (SwiftyTextAsyncLayerDisplayTask *)newAsyncDisplayTask;
@end


/// Asynchronous rendering layer, inherited from `CALayer`
/// This class is basically a copy of `YYAsyncLayer` of `YYKit`. On the basis of it, I have simplified the code
@interface SwiftyTextAsyncLayer : CALayer
@property (nonatomic, assign) BOOL displaysAsynchronously;
@end

NS_ASSUME_NONNULL_END
