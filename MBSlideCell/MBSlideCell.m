//
//  MBSlideCell.m
//  SlideToRevealCell
//
//  Created by Martina Brazelton on 6/12/13.
//  Copyright (c) 2013 Martina Brazelton. All rights reserved.
//

#import "MBSlideCell.h"
#import "MBSlideCellPanGestureRecognizer.h"

@interface MBSlideCell ()

@property (nonatomic, copy) SlideLeftBlock slideLeftBlock;
@property (nonatomic, copy) SlideRightBlock slideRightBlock;
@property (nonatomic, copy) SlideReleasedBlock slideReleasedBlock;
@property (nonatomic, strong) MBSlideCellPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) BOOL isSliding;

@end

@implementation MBSlideCell

- (id)init
{
    self = super.init;
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.backgroundView = [UIView.alloc initWithFrame:self.frame];
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self setupGestureRecognizer];
    self.enabledDirection = SlideDirectionLeft;
    self.shouldReturnAutomatically = NO;
    self.maxLeftInset = self.frame.size.width/2;
    self.maxRightInset = self.maxLeftInset;
}

- (void)setupGestureRecognizer
{
    self.panRecognizer = [MBSlideCellPanGestureRecognizer.alloc initWithTarget:self action:@selector(handlePanGesture:)];
    [self.contentView addGestureRecognizer:self.panRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

}

- (BOOL)shouldRecognizeGesture:(MBSlideCellPanGestureRecognizer *)panRecognizer
{
    SlideDirection direction = panRecognizer.direction;
    return direction == self.enabledDirection || self.enabledDirection == SlideDirectionBoth;
}

- (BOOL)shouldSlide:(SlideDirection)direction
{
    BOOL shouldSlide = YES;
    
    switch (direction) {
        case SlideDirectionLeft:
            if (CGRectGetMaxX(self.contentView.frame) < self.maxRightInset) {
                shouldSlide = NO;
            }
            break;
            
        case SlideDirectionRight:
            if (CGRectGetMinX(self.contentView.frame) > self.maxLeftInset) {
                shouldSlide = NO;
            }
            break;
            
        default:
            shouldSlide = NO;
            break;
    }
    
    return shouldSlide;
}

- (BOOL)shouldSlideToMaxInset:(SlideDirection)direction
{
    CGFloat width = self.contentView.frame.size.width;
    BOOL shouldSlideToMaxInset = NO;
    
    switch (direction) {
        case SlideDirectionLeft: {
            if (CGRectGetMaxX(self.contentView.frame) < (width - self.maxRightInset/2)) {
                shouldSlideToMaxInset = YES;
            }
            break;
        }
        
        case SlideDirectionRight: {
            if (CGRectGetMinX(self.contentView.frame) > (self.maxLeftInset/2)) {
                shouldSlideToMaxInset = YES;
            }
            break;
        }
            
        default:
            break;
    }
    
    return shouldSlideToMaxInset;
}

- (void)handlePanGesture:(MBSlideCellPanGestureRecognizer *)panRecognizer
{
    UIGestureRecognizerState state = panRecognizer.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
            self.startPoint = panRecognizer.view.center;
            break;
    
        case UIGestureRecognizerStateChanged:
            if ([self shouldRecognizeGesture:panRecognizer]) {
                [self slideContentView:panRecognizer];
                self.isSliding = YES;
            } else if (self.isSliding) {
                [self slideContentView:panRecognizer];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            [self slideGestureEnded:panRecognizer];
            self.isSliding = NO;
            break;
            
        default:
            [self slideContentViewToCenter];
            break;
    }
}

- (void)slideGestureEnded:(MBSlideCellPanGestureRecognizer *)panGestureRecognizer
{
    if (self.slideReleasedBlock) {
        self.slideReleasedBlock(self, panGestureRecognizer);
    }
    
    if (self.shouldReturnAutomatically) {
        [self slideContentViewToCenter];
    } else {
        if ([self shouldSlideToMaxInset:panGestureRecognizer.direction]) {
            [self slideContentViewToMaxInset:panGestureRecognizer.direction];
        } else {
            [self slideContentViewToCenter];
        }
    }
}

- (void)slideContentView:(MBSlideCellPanGestureRecognizer *)panRecognizer
{
    CGPoint translation = [panRecognizer translationInView:panRecognizer.view];
    CGFloat x = translation.x;
    SlideDirection direction = panRecognizer.direction;
    
    if (direction == SlideDirectionLeft) {
        if (self.slideLeftBlock) {
            self.slideLeftBlock(self, panRecognizer);
        }
    } else if (direction == SlideDirectionRight) {
        if (self.slideRightBlock) {
            self.slideRightBlock(self, panRecognizer);
        }
    }
    
    if ([self shouldSlide:direction]) {
        [self slideContentViewTo:x];
    }
}

- (void)slideContentViewTo:(CGFloat)centerX
{
    CGFloat x = self.startPoint.x + centerX;
    CGFloat y = self.centerY;
    
    [self slideContentViewToPoint:CGPointMake(x, y) animated:YES];
}

- (void)slideContentViewToCenter
{
    CGPoint center = CGPointMake(self.center.x, self.centerY);
    [self slideContentViewToPoint:center animated:YES];
}

- (void)slideContentViewToMaxInset:(SlideDirection)direction
{
    CGFloat x = self.centerX;
    CGFloat width = self.contentView.frame.size.width;
    CGFloat rightEdge = CGRectGetMaxX(self.frame);
    CGFloat leftEdge = CGRectGetMinX(self.frame);
    
    switch (direction) {
        case SlideDirectionLeft:
            x = rightEdge - self.maxRightInset - (width/2);
            break;
        case SlideDirectionRight:
            x = leftEdge + self.maxLeftInset + (width/2);
            break;
        default:
            break;
    }
    CGPoint point = CGPointMake(x, self.centerY);
    [self slideContentViewToPoint:point animated:YES];
}

- (void)slideContentViewToPoint:(CGPoint)point animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.6
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.contentView.center = point;
                         }
                         completion:nil];
    } else {
        self.contentView.center = point;
    }
}

- (CGFloat)centerX
{
    return self.contentView.center.x;
}

- (CGFloat)centerY
{
    return self.contentView.center.y;
}

@end
