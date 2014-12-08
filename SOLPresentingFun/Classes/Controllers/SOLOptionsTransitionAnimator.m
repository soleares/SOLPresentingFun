//
//  SOLOptionsTransitionAnimator.m
//  PresentingFun
//
//  Created by Jesse Wolff on 10/31/13.
//  Copyright (c) 2013 Soleares, Inc. All rights reserved.
//

#import "SOLOptionsTransitionAnimator.h"

static CGFloat const kInitialScale = 0.01;
static CGFloat const kFinalScale = 0.9;

@implementation SOLOptionsTransitionAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // Presenting
    if (self.appearing) {
        fromView.userInteractionEnabled = NO;
        
        // Round the corners
        toView.layer.cornerRadius = 5;
        toView.layer.masksToBounds = YES;
        
        // Set initial scale to zero
        toView.transform = CGAffineTransformMakeScale(kInitialScale, kInitialScale);
        [containerView addSubview:toView];
        
        // Scale up to 90%
        [UIView animateWithDuration:duration animations: ^{
            toView.transform = CGAffineTransformMakeScale(kFinalScale, kFinalScale);
            fromView.alpha = 0.5;
        } completion: ^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    // Dismissing
    else {
        
        // Scale down to 0
        [UIView animateWithDuration:duration animations: ^{
            fromView.transform = CGAffineTransformMakeScale(kInitialScale, kInitialScale);
            toView.alpha = 1.0;
        } completion: ^(BOOL finished) {
            [fromView removeFromSuperview];
            toView.userInteractionEnabled = YES;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
