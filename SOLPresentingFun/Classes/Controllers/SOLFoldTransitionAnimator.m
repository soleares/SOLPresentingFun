//
//  SOLFoldTransitionAnimator.m
//  PresentingFun
//
//  Created by Jesse Wolff on 10/31/13.
//  Copyright (c) 2013 Soleares, Inc. All rights reserved.
//

#import "SOLFoldTransitionAnimator.h"

static CGFloat const kInitialScale = 0.001;

@implementation SOLFoldTransitionAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    CGFloat duration = [self transitionDuration:transitionContext];
    
    // Take a full snapshot of the view we're transitioning to/from
    UIView *fullSnapshot;
    if (self.appearing) {
        fullSnapshot = [toView snapshotViewAfterScreenUpdates:YES]; // YES because the view hasn't been rendered yet.
    } else {
        fullSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
    }

    //
    // Take snapshots of regions we'll be animating
    //
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    
    // Bottom Left Quadrant
    CGRect bottomLeftRect = CGRectMake(CGRectGetMinX(initialFrame),
                                       CGRectGetMidY(initialFrame),
                                       CGRectGetWidth(initialFrame) / 2.0,
                                       CGRectGetHeight(initialFrame) / 2.0);
    
    UIView *bottomLeftSnapshot = [fullSnapshot resizableSnapshotViewFromRect:bottomLeftRect
                                                          afterScreenUpdates:NO
                                                               withCapInsets:UIEdgeInsetsZero];
    
    // Bottom Right Quadrant
    CGRect bottomRightRect = CGRectMake(CGRectGetMidX(initialFrame),
                                        CGRectGetMidY(initialFrame),
                                        CGRectGetWidth(initialFrame) / 2.0,
                                        CGRectGetHeight(initialFrame) / 2.0);
    
    UIView *bottomRightSnapshot = [fullSnapshot resizableSnapshotViewFromRect:bottomRightRect
                                                           afterScreenUpdates:NO
                                                                withCapInsets:UIEdgeInsetsZero];
    
    // Top Half
    CGRect topHalfRect = CGRectMake(CGRectGetMinX(initialFrame),
                                    CGRectGetMinY(initialFrame),
                                    CGRectGetWidth(initialFrame),
                                    CGRectGetHeight(initialFrame) / 2.0);
    
    UIView *topHalfSnapshot = [fullSnapshot resizableSnapshotViewFromRect:topHalfRect
                                                       afterScreenUpdates:NO
                                                            withCapInsets:UIEdgeInsetsZero];
    
    // Bottom Half
    CGRect bottomHalfRect = CGRectMake(CGRectGetMinX(initialFrame),
                                       CGRectGetMidY(initialFrame),
                                       CGRectGetWidth(initialFrame),
                                       CGRectGetHeight(initialFrame) / 2.0);
    
    UIView *bottomHalfSnapshot = [fullSnapshot resizableSnapshotViewFromRect:bottomHalfRect
                                                          afterScreenUpdates:NO
                                                               withCapInsets:UIEdgeInsetsZero];

    // Presenting
    if (self.appearing) {
        
        //
        // Add the snapshots
        //
        
        // Bottom Right - flipped horizontally and vertically
        bottomRightSnapshot.transform = CGAffineTransformMakeScale(-kInitialScale, -kInitialScale);
        [containerView addSubview:bottomRightSnapshot];
        
        // Bottom Left - flipped vertically
        bottomLeftSnapshot.alpha = 0.0;
        bottomLeftSnapshot.transform = CGAffineTransformMakeScale(1, -1);
        [containerView insertSubview:bottomLeftSnapshot belowSubview:bottomRightSnapshot];

        // Bottom Half - flipped vertically
        bottomHalfSnapshot.alpha = 0.0;
        bottomHalfSnapshot.transform = CGAffineTransformMakeScale(1, -1);
        bottomHalfSnapshot.layer.anchorPoint = CGPointMake(0.5, 0.0);
        bottomHalfSnapshot.layer.position = CGPointMake(bottomHalfSnapshot.layer.position.x, CGRectGetMidY(initialFrame));
        [containerView addSubview:bottomHalfSnapshot];
        
        // Top Half
        topHalfSnapshot.alpha = 0.0;
        [containerView insertSubview:topHalfSnapshot belowSubview:bottomHalfSnapshot];
        
        //
        // Animate the snapshots
        //
        
        [UIView animateKeyframesWithDuration:duration delay:0.0 options:0 animations:^{
            
            // Keyframe 1 - Scale up the bottom right snapshot.
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.33 animations:^{
                bottomRightSnapshot.transform = CGAffineTransformMakeScale(-1, -1);
                bottomRightSnapshot.layer.anchorPoint = CGPointMake(0.0, 0.5);
                bottomRightSnapshot.layer.position = CGPointMake(CGRectGetMidX(initialFrame), bottomRightSnapshot.layer.position.y);
            }];
            
            // Keyframe 2 - Show the bottom left snapshot
            // It's still under the bottom right snapshot but will become visible
            // in the next keyframe. This runs immediately without animation.
            [UIView addKeyframeWithRelativeStartTime:0.33 relativeDuration:0 animations:^{
                bottomLeftSnapshot.alpha = 1.0;
            }];
            
            // Keyframe 3 - Rotate the bottom right snapshot 180º along the y axis.
            // This reveals the bottom right snapshot.
            [UIView addKeyframeWithRelativeStartTime:0.33 relativeDuration:0.33 animations:^{
                CATransform3D rotationTransform = CATransform3DMakeAffineTransform(bottomRightSnapshot.transform);
                rotationTransform = CATransform3DRotate(rotationTransform, M_PI, 0.0, 1.0, 0.0);
                bottomRightSnapshot.layer.transform = rotationTransform;
            }];
            
            // Keyframe 4 - Show the bottom/top half snapshots.
            // The top half snapshot is still hidden the bottom half snapshot but
            // will become visible in the next keyframe. This runs immediately without animation.
            [UIView addKeyframeWithRelativeStartTime:0.66 relativeDuration:0 animations:^{
                bottomHalfSnapshot.alpha = 1.0;
                topHalfSnapshot.alpha = 1.0;
            }];
            
            // Keyframe 5 - Rotate the bottom half snapshot 180º along the x axis.
            // This reveals the top half snapshot.
            [UIView addKeyframeWithRelativeStartTime:0.66 relativeDuration:0.34 animations:^{
                CATransform3D rotationTransform = CATransform3DMakeAffineTransform(bottomHalfSnapshot.transform);
                rotationTransform = CATransform3DRotate(rotationTransform, M_PI - 0.01, 1.0, 0.0, 0.0);
                bottomHalfSnapshot.layer.transform = rotationTransform;
            }];
            
        } completion:^(BOOL finished) {
            // Remove the snapshots
            [bottomRightSnapshot removeFromSuperview];
            [bottomLeftSnapshot removeFromSuperview];
            [bottomHalfSnapshot removeFromSuperview];
            [topHalfSnapshot removeFromSuperview];
            
            // Show the to view
            [containerView addSubview:toView];
            
            // Set the transition complete
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    // Dismissing
    else {
        
        // Remove the from view (the snapshots will take it's place)
        [fromView removeFromSuperview];
        
        // Add the to view (it will be behind the snapshots)
        [containerView addSubview:toView];
        
        //
        // Add the snapshots
        //
        
        // Bottom Right - flipped vertically
        bottomRightSnapshot.alpha = 0.0;
        bottomRightSnapshot.transform = CGAffineTransformMakeScale(1, -1);
        bottomRightSnapshot.layer.anchorPoint = CGPointMake(0.0, 0.5);
        bottomRightSnapshot.layer.position = CGPointMake(CGRectGetMidX(initialFrame), bottomRightSnapshot.layer.position.y);
        [containerView addSubview:bottomRightSnapshot];
        
        // Bottom Left - flipped vertically
        bottomLeftSnapshot.alpha = 0.0;
        bottomLeftSnapshot.transform = CGAffineTransformMakeScale(1, -1);
        [containerView insertSubview:bottomLeftSnapshot belowSubview:bottomRightSnapshot];
        
        // Bottom Half
        bottomHalfSnapshot.layer.anchorPoint = CGPointMake(0.5, 0.0);
        bottomHalfSnapshot.layer.position = CGPointMake(bottomHalfSnapshot.layer.position.x, CGRectGetMidY(initialFrame));
        [containerView addSubview:bottomHalfSnapshot];
        
        // Top Half
        [containerView insertSubview:topHalfSnapshot belowSubview:bottomHalfSnapshot];
        
        //
        // Animate the snapshots
        //

        [UIView animateKeyframesWithDuration:duration delay:0.0 options:0 animations:^{
            
            // Keyframe 1 - Rotate the bottom half snapshot 180º along the x axis.
            // This reveals the top half snapshot.
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.33 animations:^{
                CATransform3D rotationTransform = CATransform3DMakeAffineTransform(bottomHalfSnapshot.transform);
                rotationTransform = CATransform3DRotate(rotationTransform, M_PI - 0.01, 1.0f, 0.0f, 0.0f);
                bottomHalfSnapshot.layer.transform = rotationTransform;
            }];
            
            // Keyframe 2 - Show the bottom right/left snapshots and hide the bottom/top half snapshots.
            // This runs immediately without animation.
            [UIView addKeyframeWithRelativeStartTime:0.33 relativeDuration:0 animations:^{
                bottomRightSnapshot.alpha = 1.0;
                bottomLeftSnapshot.alpha = 1.0;
                bottomHalfSnapshot.alpha = 0.0;
                topHalfSnapshot.alpha = 0.0;
            }];
            
            // Keyframe 3 - Rotate the bottom right snapshot 180º along the y axis.
            // This hides the bottom left snapshot.
            [UIView addKeyframeWithRelativeStartTime:0.33 relativeDuration:0.33 animations:^{
                CATransform3D rotationTransform = CATransform3DMakeAffineTransform(bottomRightSnapshot.transform);
                rotationTransform = CATransform3DRotate(rotationTransform, -(M_PI - 0.01), 0.0f, 1.0f, 0.0f);
                bottomRightSnapshot.layer.transform = rotationTransform;
            }];
            
            // Keyframe 4 - Scale down the bottom right/left snapshots.
            [UIView addKeyframeWithRelativeStartTime:0.66 relativeDuration:0.34 animations:^{
                CGAffineTransform transform = CGAffineTransformMakeTranslation(-CGRectGetMidX(bottomRightSnapshot.bounds), 0);
                bottomRightSnapshot.transform = CGAffineTransformScale(transform, kInitialScale, kInitialScale);
                bottomLeftSnapshot.transform = CGAffineTransformMakeScale(kInitialScale, kInitialScale);
            }];
            
        } completion:^(BOOL finished) {
            // Remove the snapshots
            [bottomRightSnapshot removeFromSuperview];
            [bottomLeftSnapshot removeFromSuperview];
            [bottomHalfSnapshot removeFromSuperview];
            [topHalfSnapshot removeFromSuperview];
            
            // Set the transition complete
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
