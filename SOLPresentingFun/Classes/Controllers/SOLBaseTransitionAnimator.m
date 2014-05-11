//
//  SOLBaseTransitionAnimator.m
//  PresentingFun
//
//  Created by Jesse Wolff on 10/31/13.
//  Copyright (c) 2013 Soleares, Inc. All rights reserved.
//

#import "SOLBaseTransitionAnimator.h"

static NSTimeInterval const kDefaultDuration = 1.0;

@implementation SOLBaseTransitionAnimator

- (id)init
{
    self = [super init];
    if (self) {
        _duration = kDefaultDuration;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Must be implemented by inheriting class
    [self doesNotRecognizeSelector:_cmd];
}

@end
