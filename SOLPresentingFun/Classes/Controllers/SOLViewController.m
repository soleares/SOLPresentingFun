//
//  SOLViewController.m
//  PresentingFun
//
//  Created by Jesse Wolff on 10/31/13.
//  Copyright (c) 2013 Soleares, Inc. All rights reserved.
//

#import "SOLBounceTransitionAnimator.h"
#import "SOLBounceViewController.h"
#import "SOLCollectionViewController.h"
#import "SOLDropTransitionAnimator.h"
#import "SOLDropViewController.h"
#import "SOLFoldTransitionAnimator.h"
#import "SOLFoldViewController.h"
#import "SOLModalTransitionAnimator.h"
#import "SOLOptions.h"
#import "SOLOptionsViewController.h"
#import "SOLSlideTransitionAnimator.h"
#import "SOLSlideViewController.h"
#import "SOLViewController.h"

// Table view sections
typedef NS_ENUM(NSInteger, TableViewSection) {
    TableViewSectionBasic,
    TableViewSectionSpring,
    TableViewSectionKeyframe,
    TableViewSectionCollectionView,
    TableViewSectionDynamics
};

// Segue Ids
static NSString * const kSegueBounceModal    = @"bounceModal";
static NSString * const kSegueBouncePush     = @"bouncePush";
static NSString * const kSegueDropDismiss    = @"dropDismiss";
static NSString * const kSegueDropModal      = @"dropModal";
static NSString * const kSegueFoldModal      = @"foldModal";
static NSString * const kSegueFoldPush       = @"foldPush";
static NSString * const kSegueOptionsDismiss = @"optionsDismiss";
static NSString * const kSegueOptionsModal   = @"optionsModal";
static NSString * const kSegueSlideModal     = @"slideModal";
static NSString * const kSegueSlidePush      = @"slidePush";

@interface SOLViewController () <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>
@end

@implementation SOLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup the tableview background view
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [backgroundView addSubview:imageView];
    
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectZero];
    maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    maskView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
    [backgroundView addSubview:maskView];
    
    self.tableView.backgroundView = backgroundView;
}

/* 
 Prepare for segue
 
 navigationController.delegate:
 We need to set the UINavigationControllerDelegate everytime for push transitions. 
 This is necessary because this VC presents multiple VCs, some with custom transitions
 (Options, Slide, Bounce, Fold, Drop) and one with a standard transition (Flow 1).
 The delegate is set to self for the custom transitions so that they work with 
 the navigation controller. The delegate is set to nil for the standard transition
 so that the default interactive pop transition works.
 
 modalPresentationStyle:
 Specify UIModalPresentationCustom for transitions where the source VC should
 stay in the view hierarchy after the transition is complete (Options, Drop). 
 For the other cases (Slide, Bounce, Fold) we don't set it which defaults it
 to UIModalPresentationFullScreen.
 
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Options - modal
    if ([segue.identifier isEqualToString:kSegueOptionsModal]) {
        UIViewController *toVC = segue.destinationViewController;
        toVC.modalPresentationStyle = UIModalPresentationCustom;
        toVC.transitioningDelegate = self;
    }
    // Slide - push
    else if ([segue.identifier isEqualToString:kSegueSlidePush]) {
        self.navigationController.delegate = self;
        UIViewController *toVC = segue.destinationViewController;
        toVC.transitioningDelegate = self;
    }
    // Slide - modal
    else if ([segue.identifier isEqualToString:kSegueSlideModal]) {
        UIViewController *toVC = segue.destinationViewController;
        toVC.transitioningDelegate = self;
    }
    // Bounce - push
    else if ([segue.identifier isEqualToString:kSegueBouncePush]) {
        self.navigationController.delegate = self;
        UIViewController *toVC = segue.destinationViewController;
        toVC.transitioningDelegate = self;
    }
    // Bounce - modal
    else if ([segue.identifier isEqualToString:kSegueBounceModal]) {
        UIViewController *toVC = segue.destinationViewController;
        toVC.transitioningDelegate = self;
    }
    // Fold - push
    else if ([segue.identifier isEqualToString:kSegueFoldPush]) {
        self.navigationController.delegate = self;
        UIViewController *toVC = segue.destinationViewController;
        toVC.transitioningDelegate = self;
    }
    // Fold - modal
    else if ([segue.identifier isEqualToString:kSegueFoldModal]) {
        UIViewController *toVC = segue.destinationViewController;
        toVC.transitioningDelegate = self;
    }
    // Drop - modal
    else if ([segue.identifier isEqualToString:kSegueDropModal]) {
        UIViewController *toVC = segue.destinationViewController;
        toVC.modalPresentationStyle = UIModalPresentationCustom;
        toVC.transitioningDelegate = self;
    }
    
    [super prepareForSegue:segue sender:sender];
}

#pragma mark - UITableViewDelegate

/*
 Push/Present the appropriate view controller when a cell is selected.
 
 For a static table view you would typically connect the segues directly
 to the table view cells and not need this method. Because there's more
 than one possible segue per cell (push or modal) we need to trigger the 
 segue manually.
 
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    SOLOptions *options = [SOLOptions sharedOptions];
    
    switch (indexPath.section) {
        // Slide
        case TableViewSectionBasic: {
            NSString *identifier = options.pushTransitions ? kSegueSlidePush : kSegueSlideModal;
            [self performSegueWithIdentifier:identifier sender:self];
            break;
        }
        // Bounce
        case TableViewSectionSpring: {
            NSString *identifier = options.pushTransitions ? kSegueBouncePush : kSegueBounceModal;
            [self performSegueWithIdentifier:identifier sender:self];
            break;
        }
        // Fold
        case TableViewSectionKeyframe: {
            NSString *identifier = options.pushTransitions ? kSegueFoldPush : kSegueFoldModal;
            [self performSegueWithIdentifier:identifier sender:self];
            break;
        }
        // Flow 1
        // UICollectionView useLayoutToLayoutNavigationTransitions doesn't work
        // properly with segues. It works fine if you push the collection view manually.
        // The navigation controller delegate needs to be set to nil so that the
        // default interactive pop transition (swipe left) works.
        case TableViewSectionCollectionView: {
            self.navigationController.delegate = nil;
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.itemSize = CGSizeMake(150.f, 150.f);
            SOLCollectionViewController *controller = [[SOLCollectionViewController alloc] initWithCollectionViewLayout:layout];
            controller.numberOfItems = 100;
            controller.useLayoutToLayoutNavigationTransitions = NO;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        // Drop
        case TableViewSectionDynamics: {
            [self performSegueWithIdentifier:kSegueDropModal sender:self];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

/*
 Called when presenting a view controller that has a transitioningDelegate
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    id<UIViewControllerAnimatedTransitioning> animationController;
    
    SOLOptions *options = [SOLOptions sharedOptions];
    
    // Options
    if ([presented isKindOfClass:[UINavigationController class]] &&
        [((UINavigationController *)presented).topViewController isKindOfClass:[SOLOptionsViewController class]]) {
        SOLModalTransitionAnimator *animator = [[SOLModalTransitionAnimator alloc] init];
        animator.appearing = YES;
        animator.duration = 0.35;
        animationController = animator;
    }
    // Slide
    else if ([presented isKindOfClass:[SOLSlideViewController class]]) {
        SOLSlideTransitionAnimator *animator = [[SOLSlideTransitionAnimator alloc] init];
        animator.appearing = YES;
        animator.duration = options.duration;
        animator.edge = options.edge;
        animationController = animator;
    }
    // Bounce
    else if ([presented isKindOfClass:[SOLBounceViewController class]]) {
        SOLBounceTransitionAnimator *animator = [[SOLBounceTransitionAnimator alloc] init];
        animator.appearing = YES;
        animator.duration = options.springDuration;
        animator.edge = options.edge;
        animator.dampingRatio = options.dampingRatio;
        animator.velocity =  options.velocity;
        animationController = animator;
    }
    // Fold
    else if ([presented isKindOfClass:[SOLFoldViewController class]]) {
        SOLFoldTransitionAnimator *animator = [[SOLFoldTransitionAnimator alloc] init];
        animator.appearing = YES;
        animator.duration = 2.5;
        animationController = animator;
    }
    // Drop
    else if ([presented isKindOfClass:[SOLDropViewController class]]) {
        SOLDropTransitionAnimator *animator = [[SOLDropTransitionAnimator alloc] init];
        animator.appearing = YES;
        animator.duration = 1.5;
        animationController = animator;
    }
    
    return animationController;
}

/*
 Called when dismissing a view controller that has a transitioningDelegate
 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    id<UIViewControllerAnimatedTransitioning> animationController;

    SOLOptions *options = [SOLOptions sharedOptions];
    
    // Options
    if ([dismissed isKindOfClass:[UINavigationController class]] &&
        [((UINavigationController *)dismissed).topViewController isKindOfClass:[SOLOptionsViewController class]]) {
        SOLModalTransitionAnimator *animator = [[SOLModalTransitionAnimator alloc] init];
        animator.appearing = NO;
        animator.duration = 0.35;
        animationController = animator;
    }
    // Slide
    else if ([dismissed isKindOfClass:[SOLSlideViewController class]]) {
        SOLSlideTransitionAnimator *animator = [[SOLSlideTransitionAnimator alloc] init];
        animator.appearing = NO;
        animator.duration = options.duration;
        animator.edge = options.edge;
        animationController = animator;
    }
    // Bounce
    else if ([dismissed isKindOfClass:[SOLBounceViewController class]]) {
        SOLBounceTransitionAnimator *animator = [[SOLBounceTransitionAnimator alloc] init];
        animator.appearing = NO;
        animator.duration = options.springDuration;
        animator.edge = options.edge;
        animator.dampingRatio = 1.0;
        animator.velocity = options.velocity;
        animationController = animator;
    }
    // Fold
    else if ([dismissed isKindOfClass:[SOLFoldViewController class]]) {
        SOLFoldTransitionAnimator *animator = [[SOLFoldTransitionAnimator alloc] init];
        animator.appearing = NO;
        animator.duration = 2.5;
        animationController = animator;
    }
    // Drop
    else if ([dismissed isKindOfClass:[SOLDropViewController class]]) {
        SOLDropTransitionAnimator *animator = [[SOLDropTransitionAnimator alloc] init];
        animator.appearing = NO;
        animator.duration = 4.0;
        animationController = animator;
    }
    
    return animationController;
}

#pragma mark - UINavigationControllerDelegate

/*
 Called when pushing/popping a view controller on a navigation controller that has a delegate
 */
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    id<UIViewControllerAnimatedTransitioning> animationController;
    
    SOLOptions *options = [SOLOptions sharedOptions];
    
    // Slide - Push
    if ([toVC isKindOfClass:[SOLSlideViewController class]] && operation == UINavigationControllerOperationPush) {
        SOLSlideTransitionAnimator *animator = [[SOLSlideTransitionAnimator alloc] init];
        animator.appearing = YES;
        animator.duration = options.duration;
        animator.edge = options.edge;
        animationController = animator;
    }
    // Slide - Pop
    else if ([fromVC isKindOfClass:[SOLSlideViewController class]] && operation == UINavigationControllerOperationPop) {
        SOLSlideTransitionAnimator *animator = [[SOLSlideTransitionAnimator alloc] init];
        animator.appearing = NO;
        animator.duration = options.duration;
        animator.edge = options.edge;
        animationController = animator;
    }
    // Bounce - Push
    else if ([toVC isKindOfClass:[SOLBounceViewController class]] && operation == UINavigationControllerOperationPush) {
        SOLBounceTransitionAnimator *animator = [[SOLBounceTransitionAnimator alloc] init];
        animator.appearing = YES;
        animator.duration = options.springDuration;
        animator.edge = options.edge;
        animator.dampingRatio = options.dampingRatio;
        animator.velocity = options.velocity;
        animationController = animator;
    }
    // Bounce - Pop
    else if ([fromVC isKindOfClass:[SOLBounceViewController class]] && operation == UINavigationControllerOperationPop) {
        SOLBounceTransitionAnimator *animator = [[SOLBounceTransitionAnimator alloc] init];
        animator.appearing = NO;
        animator.duration = options.springDuration;
        animator.edge = options.edge;
        animator.dampingRatio = 1.0;    // Critically damped
        animator.velocity = options.velocity;
        animationController = animator;
    }
    // Fold - Push
    else if ([toVC isKindOfClass:[SOLFoldViewController class]] && operation == UINavigationControllerOperationPush) {
        SOLFoldTransitionAnimator *animator = [[SOLFoldTransitionAnimator alloc] init];
        animator.appearing = YES;
        animator.duration = 2.5;
        animationController = animator;
    }
    // Fold - Pop
    else if ([fromVC isKindOfClass:[SOLFoldViewController class]] && operation == UINavigationControllerOperationPop) {
        SOLFoldTransitionAnimator *animator = [[SOLFoldTransitionAnimator alloc] init];
        animator.appearing = NO;
        animator.duration = 2.5;
        animationController = animator;
    }
    
    return animationController;
}

#pragma mark - Storyboard unwinding

/*
 Unwind segue action called to dismiss the Options and Drop view controllers and
 when the Slide, Bounce and Fold view controllers are dismissed with a single tap.
 
 Normally an unwind segue will pop/dismiss the view controller but this doesn't happen 
 for custom modal transitions so we have to manually call dismiss.
 */
- (IBAction)unwindToViewController:(UIStoryboardSegue *)sender
{
    if ([sender.identifier isEqualToString:kSegueOptionsDismiss] || [sender.identifier isEqualToString:kSegueDropDismiss]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
