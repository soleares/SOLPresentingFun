//
//  SOLCollectionViewController.m
//  PresentingFun
//
//  Created by Jesse Wolff on 10/31/13.
//  Copyright (c) 2013 Soleares, Inc. All rights reserved.
//

#import "SOLCollectionViewController.h"

static NSUInteger const kDefaultNumberOfItems = 50;
static NSUInteger const kItemSizeReduction = 50;
static NSUInteger const kMinimumItemSize = 50;
static NSString * const kCellID = @"cellID";

@implementation SOLCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _numberOfItems = kDefaultNumberOfItems;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellID];
    
    // Set the title based on the initial flow layout size
    CGSize itemSize = ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize;
    self.title = [NSString stringWithFormat:@"{%.f, %.f} Squares", itemSize.width, itemSize.height];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    // Cycle the cell background color
    CGFloat hue = (indexPath.item % 91) / 90.0;
    cell.backgroundColor = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

/* 
 Push a new collection view with cells that are reduced in size by kDetailItemSizeReduction 
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemSize.width - kItemSizeReduction,
                                 itemSize.height - kItemSizeReduction);
    SOLCollectionViewController *toVC = [[SOLCollectionViewController alloc] initWithCollectionViewLayout:layout];
    toVC.useLayoutToLayoutNavigationTransitions = YES;
    [self.navigationController pushViewController:toVC animated:YES];
}

/* 
 Don't allow the item size to be less than kMinimumItemSize 
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize;
    if (itemSize.width - kItemSizeReduction < kMinimumItemSize ||
        itemSize.height - kItemSizeReduction < kMinimumItemSize) {
        return NO;
    }
    return YES;
}

@end
