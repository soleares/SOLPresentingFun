SOLPresentingFun
================

SOLPresentingFun is sample code for WWDC Session 218: Custom Transitions Using View Controllers.

Apple didn't provide sample code for this session so it's recreated here for your perusal and enjoyment.

Storyboards are used as much as possible in this sample. This was done as an exercise and to verify that the new APIs worked with Storyboard segues.

Requires Xcode 5 and iOS 7.

#Transitions

##Slide

A custom transition that slides a view controller in from an edge.

The transition is implemented in `SOLSlideTransitionAnimator`.

##Bounce
A custom transition that slides a view controller in from an edge with bounce.

The transition is implemented in `SOLBounceTransitionAnimator`. 

##Fold
A custom transition that uses snapshots and keyframes to achieve a folding origami effect. 

The transition is implemented in `SOLFoldTransitionAnimator`. 

##Flow 1

A standard interactive transition that animates between collection view controllers and includes a standard interactive pop gesture (swipe right).

It uses a new property `useLayoutToLayoutNavigationTransitions` on `UICollectionViewController`.

##Drop
A custom modal transition that shows how to combine custom transitions with UIKit Dynamics.

The transition is implemented in `SOLDropTransitionAnimator`. 


##Options
A custom modal transition that presents an in-app settings view controller.

The transition is implemented in `SOLOptionsTransitionAnimator`.


#Issues

I came across the following issues with the new API:

1. `UICollectionViewController.useLayoutToLayoutNavigationTransitions` don't work properly with storyboard segues. This is why I push the collection view controller programmatically instead of with a segue. The issue is that it doesn't transition to the third collection view when using segues. I believe this is due to an SDK bug.

2. The keyframe animation API sometimes animates a snapshot's alpha value at the wrong time. I worked around this in `SOLFoldTransitionAnimator` by scaling down `bottomLeftSnapshot` in Keyframe 4 of the dismiss animation. I would have preferred to just set it's alpha to 0 in a prior keyframe but that didn't work. I filed a radar for this.

3. Normally an unwind segue will pop/dismiss the view controller. This doesn't happen 
 for custom modal transitions so the view controller needs to be programmatically dismissed in the unwind segue action method. See the comments for `-[SOLViewController unwindToViewController:]` for more details.
 
4. For standard interactive transitions like Flow 1, the navigation controller delegate can't be set otherwise the standard interactive pop gesture (swipe right) breaks. See the comments for `-[SOLViewController prepareForSegue:]` for more details.