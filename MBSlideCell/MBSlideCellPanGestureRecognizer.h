//
//  MBSlideCellPanGestureRecognizer.h
//  MBSlideToRevealCell
//
//  Created by Martina Brazelton on 6/13/13.
//  Copyright (c) 2013 Martina Brazelton. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>
#import "MBSlideCell.h"

@interface MBSlideCellPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, assign, readonly) SlideDirection direction;

@end
