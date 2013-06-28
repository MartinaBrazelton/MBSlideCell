//
//  MBSlideCellPanGestureRecognizer.m
//  MBSlideToRevealCell
//
//  Created by Martina Brazelton on 6/13/13.
//  Copyright (c) 2013 Martina Brazelton. All rights reserved.
//

#import "MBSlideCellPanGestureRecognizer.h"

@interface MBSlideCellPanGestureRecognizer ()

@property (nonatomic, assign, readwrite) SlideDirection direction;

@end

@implementation MBSlideCellPanGestureRecognizer

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    self.direction = self.slideDirection;
}

- (SlideDirection)slideDirection
{
    CGPoint translation = [self translationInView:self.view.superview];
    
    return translation.x < 0 ? SlideDirectionLeft : SlideDirectionRight;
}

@end
