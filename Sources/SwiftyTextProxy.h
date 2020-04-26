//
//  SwiftyTextProxy.h
//  SwiftyText
//
//  Created by apple on 2020/4/26.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Prevent strong references
/// This class is basically a copy of `YYWeakProxy` of `YYKit`
@interface SwiftyTextProxy : NSProxy
@property (nullable, nonatomic, weak, readonly) id target;
- (instancetype)initWithTarget:(id)target;
+ (instancetype)weakWithTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
