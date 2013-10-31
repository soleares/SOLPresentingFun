//
//  SOLOptions.m
//  PresentingFun
//
//  Created by Jesse Wolff on 10/31/13.
//  Copyright (c) 2013 Soleares, Inc. All rights reserved.
//

#import "SOLOptions.h"

static NSString * const kPushTransitionsKey = @"pushTransitions";
static NSString * const kDurationKey        = @"duration";
static NSString * const kEdgeKey            = @"edge";
static NSString * const kDampingRatioKey    = @"dampingRatio";
static NSString * const kVelocityKey        = @"velocity";
static NSString * const kSpringDurationKey  = @"springDuration";

@implementation SOLOptions

+ (instancetype)sharedOptions
{
    static SOLOptions *_sharedOptions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedOptions = [[self alloc] init];
    });
    
    return _sharedOptions;
}

#pragma - Getters and Setters

- (BOOL)pushTransitions
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPushTransitionsKey];
}

- (void)setPushTransitions:(BOOL)pushTransitions
{
    [[NSUserDefaults standardUserDefaults] setBool:pushTransitions forKey:kPushTransitionsKey];
}

- (NSTimeInterval)duration
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kDurationKey];
}

- (void)setDuration:(NSTimeInterval)duration
{
    [[NSUserDefaults standardUserDefaults] setDouble:duration forKey:kDurationKey];
}

- (SOLEdge)edge
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kEdgeKey];
}

- (void)setEdge:(SOLEdge)edge
{
    [[NSUserDefaults standardUserDefaults] setInteger:edge forKey:kEdgeKey];
}

- (CGFloat)dampingRatio
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kDampingRatioKey];
}

- (void)setDampingRatio:(CGFloat)dampingRatio
{
    [[NSUserDefaults standardUserDefaults] setDouble:dampingRatio forKey:kDampingRatioKey];
}

- (CGFloat)velocity
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kVelocityKey];
}

- (void)setVelocity:(CGFloat)velocity
{
    [[NSUserDefaults standardUserDefaults] setDouble:velocity forKey:kVelocityKey];
}

- (NSTimeInterval)springDuration
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kSpringDurationKey];
}

- (void)setSpringDuration:(NSTimeInterval)springDuration
{
    [[NSUserDefaults standardUserDefaults] setDouble:springDuration forKey:kSpringDurationKey];
}

@end
