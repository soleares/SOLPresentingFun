//
//  SOLSlideTransitionAnimator.m
//  PresentingFun
//
//  Created by Jesse Wolff on 10/31/13.
//  Copyright (c) 2013 Soleares, Inc. All rights reserved.
//

#import "SOLSlideTransitionAnimator.h"

@implementation SOLSlideTransitionAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect offscreenRect = [self rectOffsetFromRect:initialFrame atEdge:self.edge];
    
    // Presenting
    if (self.appearing) {
        // Position the view offscreen
        toView.frame = offscreenRect;
        [containerView addSubview:toView];
        
        // Animate the view onscreen
        [UIView animateWithDuration:duration animations: ^{
            toView.frame = initialFrame;
        } completion: ^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    // Dismissing
    else {
        [containerView addSubview:toView];
        [containerView sendSubviewToBack:toView];
        
        // Animate the view offscreen
        [UIView animateWithDuration:duration animations: ^{
            fromView.frame = offscreenRect;
        } completion: ^(BOOL finished) {
            [fromView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

#pragma mark - Helper methods

+ (NSDictionary *)edgeDisplayNames
{
    return @{@(SOLEdgeTop) : @"Top",
             @(SOLEdgeLeft) : @"Left",
             @(SOLEdgeBottom) : @"Bottom",
             @(SOLEdgeRight) : @"Right",
             @(SOLEdgeTopRight) : @"Top-Right",
             @(SOLEdgeTopLeft) : @"Top-Left",
             @(SOLEdgeBottomRight) : @"Bottom-Right",
             @(SOLEdgeBottomLeft) : @"Bottom-Left"};
}

- (CGRect)rectOffsetFromRect:(CGRect)rect atEdge:(SOLEdge)edge
{
    CGRect offsetRect = rect;
    
    switch (edge) {
        case SOLEdgeTop: {
            offsetRect.origin.y -= CGRectGetHeight(rect);
            break;
        }
        case SOLEdgeLeft: {
            offsetRect.origin.x -= CGRectGetWidth(rect);
            break;
        }
        case SOLEdgeBottom: {
            offsetRect.origin.y += CGRectGetHeight(rect);
            break;
        }
        case SOLEdgeRight: {
            offsetRect.origin.x += CGRectGetWidth(rect);
            break;
        }
        case SOLEdgeTopRight: {
            offsetRect.origin.y -= CGRectGetHeight(rect);
            offsetRect.origin.x += CGRectGetWidth(rect);
            break;
        }
        case SOLEdgeTopLeft: {
            offsetRect.origin.y -= CGRectGetHeight(rect);
            offsetRect.origin.x -= CGRectGetWidth(rect);
            break;
        }
        case SOLEdgeBottomRight: {
            offsetRect.origin.y += CGRectGetHeight(rect);
            offsetRect.origin.x += CGRectGetWidth(rect);
            break;
        }
        case SOLEdgeBottomLeft: {
            offsetRect.origin.y += CGRectGetHeight(rect);
            offsetRect.origin.x -= CGRectGetWidth(rect);
            break;
        }
        default:
            break;
    }
    
    return offsetRect;
}


@end
