//
//  MBSlideCell.h
//  MBSlideToRevealCell
//
//  Created by Martina Brazelton on 6/12/13.
//  Copyright (c) 2013 Martina Brazelton. All rights reserved.
//


@class MBSlideCellPanGestureRecognizer;

typedef enum {
    SlideDirectionLeft,
    SlideDirectionRight,
    SlideDirectionNone,
    SlideDirectionBoth,
}SlideDirection;

@class MBSlideCell;

typedef void (^SlideLeftBlock) (MBSlideCell *cell, MBSlideCellPanGestureRecognizer * panGestureRecognizer);
typedef void (^SlideRightBlock) (MBSlideCell *cell, MBSlideCellPanGestureRecognizer * panGestureRecognizer);
typedef void (^SlideReleasedBlock) (MBSlideCell *cell, MBSlideCellPanGestureRecognizer * panGestureRecognizer);

@interface MBSlideCell : UITableViewCell

@property (nonatomic, assign) SlideDirection enabledDirection;
@property (nonatomic, assign) CGFloat maxLeftInset;
@property (nonatomic, assign) CGFloat maxRightInset;
@property (nonatomic, assign) BOOL shouldReturnAutomatically;

- (void)setSlideLeftBlock:(SlideLeftBlock)block;
- (void)setSlideRightBlock:(SlideRightBlock)block;
- (void)setSlideReleasedBlock:(SlideReleasedBlock)block;

@end
