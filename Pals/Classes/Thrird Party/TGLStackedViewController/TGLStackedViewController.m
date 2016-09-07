//
//  TGLStackedViewController.m
//  TGLStackedViewController
//
//  Created by Tim Gleue on 07.04.14.
//  Copyright (c) 2014 Tim Gleue ( http://gleue-interactive.com )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "TGLStackedViewController.h"
#import "TGLBackgroundProxyView.h"

@interface TGLStackedViewController () <UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) TGLStackedLayout *stackedLayout;
@property (nonatomic, strong) TGLExposedLayout *exposedLayout;

@property (nonatomic, assign) BOOL interactiveTransitionInProgress;

@end

@implementation TGLStackedViewController

+ (Class)exposedLayoutClass {

    return TGLExposedLayout.class;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    
    if (self) [self initController];
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) [self initController];
    
    return self;
}

- (void)initController {
    
    _exposedLayoutMargin = UIEdgeInsetsMake(60.0, 0.0, 0.0, 0.0);
    _exposedItemSize = CGSizeZero;
    _exposedTopOverlap = 5;//10.0;
    _exposedBottomOverlap = 5;//10.0;
    _exposedBottomOverlapCount = 1;
    
    _exposedPinningMode = TGLExposedLayoutPinningModeAll;
//    _exposedTopPinningCount = -1;
//    _exposedBottomPinningCount = -1;
    
    _exposedItemsAreCollapsible = YES;
    
    _movingItemScaleFactor = 0.95;

    _collapsePanMinimumThreshold = 120.0;
    _collapsePanMaximumThreshold = 0.0;
    _collapsePinchMinimumThreshold = 0.25;
    
}

#pragma mark - View life cycle

- (void)viewDidLoad {

    [super viewDidLoad];
    
    NSAssert([self.collectionView.collectionViewLayout isKindOfClass:TGLStackedLayout.class], @"TGLStackedViewController collection view layout is not a TGLStackedLayout");
    
    self.stackedLayout = (TGLStackedLayout *)self.collectionView.collectionViewLayout;
    
    //custom setup
    self.stackedLayout.topReveal = 60;
    self.exposedPinningMode = TGLExposedLayoutPinningModeBelow;
    self.exposedTopPinningCount = 5;
    self.exposedBottomPinningCount = 5;
    self.exposedItemsAreCollapsible = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.collectionView.backgroundColor = [UIColor clearColor]; //need for collection background view
}

#pragma mark - UICollectionViewDelegate protocol

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {

    // When selecting unexposed items is not allowed,
    // prevent them from being highlighted and thus
    // selected by the collection view
    //
    // Issue #37: Prevent selection, too, while interactive transition is still in progress.
    //
    return (self.exposedItemIndexPath == nil || indexPath.item == self.exposedItemIndexPath.item || self.unexposedItemsAreSelectable) && !self.interactiveTransitionInProgress;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // When selecting unexposed items is not allowed
    // make sure the currently exposed item remains
    // selected
    //
    if (self.exposedItemIndexPath && indexPath.item == self.exposedItemIndexPath.item) {
        
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (void)setExposedItemIndexPath:(nullable NSIndexPath *)exposedItemIndexPath {
    
    [self setExposedItemIndexPath:exposedItemIndexPath animated:YES];
}

- (void)setExposedItemIndexPath:(nullable NSIndexPath *)exposedItemIndexPath animated:(BOOL)animated {
    
    if (self.exposedItemIndexPath == nil && exposedItemIndexPath) {
        
        // Exposed item while none is exposed yet
        //
        self.stackedLayout.contentOffset = self.collectionView.contentOffset;
        
        TGLExposedLayout *exposedLayout = [[[self.class exposedLayoutClass] alloc] initWithExposedItemIndex:exposedItemIndexPath.item];
        
        exposedLayout.layoutMargin = self.exposedLayoutMargin;
        exposedLayout.itemSize = self.exposedItemSize;
        exposedLayout.topOverlap = self.exposedTopOverlap;
        exposedLayout.bottomOverlap = self.exposedBottomOverlap;
        exposedLayout.bottomOverlapCount = self.exposedBottomOverlapCount;
        
        exposedLayout.pinningMode = self.exposedPinningMode;
        exposedLayout.topPinningCount = self.exposedTopPinningCount;
        exposedLayout.bottomPinningCount = self.exposedBottomPinningCount;
        
        __weak typeof(self) weakSelf = self;
        
        void (^completion) (BOOL) = ^ (BOOL finished) {
            
            weakSelf.stackedLayout.overwriteContentOffset = YES;
            weakSelf.exposedLayout = exposedLayout;
            
            _exposedItemIndexPath = exposedItemIndexPath;
            
        };
        
        if (animated) {
            
            [self.collectionView setCollectionViewLayout:exposedLayout animated:YES completion:completion];
            
        } else {
            
            self.collectionView.collectionViewLayout = exposedLayout;
            
            completion(YES);
        }
        
        
    } else if (self.exposedItemIndexPath && exposedItemIndexPath && (exposedItemIndexPath.item != self.exposedItemIndexPath.item || self.unexposedItemsAreSelectable)) {
        
        // We have another exposed item and we expose the new one instead
        //
        TGLExposedLayout *exposedLayout = [[TGLExposedLayout alloc] initWithExposedItemIndex:exposedItemIndexPath.item];
        
        exposedLayout.layoutMargin = self.exposedLayout.layoutMargin;
        exposedLayout.itemSize = self.exposedLayout.itemSize;
        exposedLayout.topOverlap = self.exposedLayout.topOverlap;
        exposedLayout.bottomOverlap = self.exposedLayout.bottomOverlap;
        exposedLayout.bottomOverlapCount = self.exposedLayout.bottomOverlapCount;
        
        exposedLayout.pinningMode = self.exposedLayout.pinningMode;
        exposedLayout.topPinningCount = self.exposedLayout.topPinningCount;
        exposedLayout.bottomPinningCount = self.exposedLayout.bottomPinningCount;
        
        __weak typeof(self) weakSelf = self;
        
        void (^completion) (BOOL) = ^ (BOOL finished) {
            
            weakSelf.exposedLayout = exposedLayout;
            
            _exposedItemIndexPath = exposedItemIndexPath;
            
        };
        
        if (animated) {
            
            [self.collectionView setCollectionViewLayout:exposedLayout animated:YES completion:completion];
            
        } else {
            
            self.collectionView.collectionViewLayout = exposedLayout;
            
            completion(YES);
        }
        
    } else if (self.exposedItemIndexPath) {
        
        // We collapse the currently exposed item because
        //
        // 1. -exposedItemIndexPath has been set to nil or
        // 2. we're not allowed to collapse by selecting a new item
        //
        [self.collectionView deselectItemAtIndexPath:self.exposedItemIndexPath animated:YES];
                
        self.exposedLayout = nil;
        
        _exposedItemIndexPath = nil;
        
        __weak typeof(self) weakSelf = self;
        
        void (^completion) (BOOL) = ^ (BOOL finished) {
            
            weakSelf.stackedLayout.overwriteContentOffset = NO;
        };
        
        if (animated) {
            
            [self.collectionView setCollectionViewLayout:self.stackedLayout animated:YES completion:completion];
            
        } else {
            
            self.collectionView.collectionViewLayout = self.stackedLayout;
            
            completion(YES);
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.exposedItemIndexPath && indexPath.item == self.exposedItemIndexPath.item) {

        self.exposedItemIndexPath = nil;

    } else {
        
        self.exposedItemIndexPath = indexPath;
    }
}

#pragma mark - UICollectionViewDataSource protocol

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    // Currently, only one single section is
    // supported, therefore MUST NOT be != 1
    //
    return 1;
}

#pragma mark - Helpers

- (void)setupCollectionBackgroundView:(UIView *)backgroundView {
    CGRect newFrame = self.collectionView.bounds;
    newFrame.size.width = self.view.bounds.size.width;
    backgroundView.frame = newFrame;
    self.collectionView.frame = newFrame;
    [self.view insertSubview:backgroundView belowSubview:self.collectionView];
    TGLBackgroundProxyView * backgroundProxy = [[TGLBackgroundProxyView alloc] init];
    backgroundProxy.targetView = backgroundView;
    self.collectionView.backgroundView = backgroundProxy;
}

@end
