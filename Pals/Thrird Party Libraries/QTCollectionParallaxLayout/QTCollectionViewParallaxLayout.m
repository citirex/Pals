//
//  QTCollectionViewParallaxLayout.m
//  Quam Test
//
//  Created by ruckef on 17.03.16.
//  Copyright © 2016 ruckef. All rights reserved.
//

#import "QTCollectionViewParallaxLayout.h"

@implementation QTCollectionViewParallaxLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    UICollectionView *collectionView = [self collectionView];
    CGFloat contentOffset = [collectionView contentOffset].y;
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    UICollectionViewLayoutAttributes *mainHeaderAttributes = nil;
    UICollectionViewLayoutAttributes *stickyHeaderAttributes = nil;
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            if (attr.indexPath.section == 0) {
                mainHeaderAttributes = attr;
            } else {
                stickyHeaderAttributes = attr;
            }
        } else {
            attr.zIndex = 1;
        }
    }
    
    CGFloat mainHeaderHeight = 0;
    if (mainHeaderAttributes) {
        CGRect mainHeaderFrame = mainHeaderAttributes.frame;
        mainHeaderFrame.origin.y = contentOffset/3.0;
        mainHeaderAttributes.frame = mainHeaderFrame;
        mainHeaderAttributes.zIndex = 0;
        if (mainHeaderHeight != mainHeaderFrame.size.height) {
            mainHeaderHeight = mainHeaderFrame.size.height;
        }
    }
    
    if (!stickyHeaderAttributes) {
        stickyHeaderAttributes = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
        [attributes addObject:stickyHeaderAttributes];
    }

    CGRect stickyHeaderFrame = stickyHeaderAttributes.frame;
    if (contentOffset >= mainHeaderHeight) {
        stickyHeaderFrame.origin.y = contentOffset;
        stickyHeaderAttributes.frame = stickyHeaderFrame;
    }
    stickyHeaderAttributes.zIndex = 1024;
    return attributes;
}

@end
