//
//  UIView+layout.m
//  BookApp
//
//  Created by Nalin on 11/15/12.
//
//

#import "UIView+LayoutUtil.h"
#import "UIView+FrameUtil.h"

@implementation UIView (LayoutUtil)

- (void)stickToBottomOf: (UIView *) superView {
    CGRect frame = self.frame;
    frame.origin.y = superView.frame.size.height - frame.size.height;
    self.frame = frame;
    [superView addSubview:self];
}

- (void)putInTopOf: (UIView *) superView withMargin: (CGFloat) margin{
    self.y = margin;
    [superView addSubview:self];
}

- (void)putInBottomOf: (UIView *) superView withMargin: (CGFloat) margin{
    self.y = superView.height - self.height - margin;
    [superView addSubview:self];
}

- (void) putInCenterOf: (UIView *) superView withMargin: (CGFloat) margin {
    [self positionCenterOf:superView withMargin:margin];
    [superView addSubview:self];
}

- (void) positionCenterOf: (UIView *) superView withMargin: (CGFloat) margin {
    self.frame = CGRectMake(margin, margin, superView.frame.size.width - 2 * margin, superView.frame.size.height - 2 * margin);
}

- (void) putInRightEdgeOf: (UIView *) superView withMargin: (CGFloat) margin {
    CGRect frame = self.frame;
    frame.origin.x = superView.frame.size.width - frame.size.width - margin;
    self.frame = frame;
    [superView addSubview:self];
}

- (void) putInLeftEdgeOf: (UIView *) superView withMargin: (CGFloat) margin {
    self.x = margin;
    [superView addSubview:self];
}

- (void) positionLeftOf: (UIView *) anchorView withMargin: (CGFloat) margin {
    CGRect frame = self.frame;
    frame.origin.x = anchorView.x - self.width - margin;
    frame.origin.y = anchorView.y;
    self.frame = frame;
    [anchorView.superview addSubview:self];
}

- (void)positionAbove: (UIView *) anchorView withMargin: (CGFloat) margin {
    self.y = anchorView.y - self.height - margin;
}

- (void) putToRightOf: (UIView *) anchorView withMargin: (CGFloat) margin {
    CGRect frame = self.frame;
    frame.origin.x = anchorView.x + anchorView.width + margin;
    frame.origin.y = anchorView.y;
    self.frame = frame;
    [anchorView.superview addSubview:self];
}

- (void)putToLeftOf: (UIView *) anchorView withMargin: (CGFloat) margin {
    self.x = anchorView.x - self.width - margin;
    [anchorView.superview addSubview:self];
}

- (void) putBelow: (UIView *) anchorView withMargin: (CGFloat) margin {
    CGRect frame = self.frame;
    frame.origin.y = anchorView.y + anchorView.height + margin;
    frame.origin.x = anchorView.x;
    self.frame = frame;
    [anchorView.superview addSubview:self];
}

@end
