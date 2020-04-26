//
//  SwiftyTextProxy.m
//  SwiftyText
//
//  Created by apple on 2020/4/26.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import "SwiftyTextProxy.h"

@implementation SwiftyTextProxy
- (instancetype)initWithTarget:(id)target{
    _target = target;
    return self;
}

+ (instancetype)weakWithTarget:(id)target{
    return [[SwiftyTextProxy alloc] initWithTarget:target];
}

#pragma mark The following methods are all rewritten
// This method is commented out in the `NSProxy` header file, but `YYWeakProxy` still has this method.
// The test found that if this method is commented out, the callbacks of `Timer` and `CADisplayLink` will not be executed
// So, the message forwarding just needs to be sorted out carefully
- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector{
    return [_target respondsToSelector:aSelector];
}

- (BOOL)isEqual:(id)object{
    return [_target isEqual:object];
}

- (NSUInteger)hash{
    return [_target hash];
}

- (Class)superclass{
    return [_target superclass];
}

- (Class)class{
    return [_target class];
}

- (BOOL)isKindOfClass:(Class)aClass{
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass{
    return [_target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol{
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)isProxy{
    return YES;
}

- (NSString *)description{
    return [_target description];
}

- (NSString *)debugDescription{
    return [_target debugDescription];
}

@end
