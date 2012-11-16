//
//  UIView+layout.m
//  BookApp
//
//  Created by Nalin on 11/15/12.
//
//

#import "UIView+LayoutUtil.h"

@implementation UIView (LayoutUtil)

- (void)stickToBottomOf: (UIView *) superView {
    CGRect frame = self.frame;
    frame.origin.y = superView.frame.size.height - frame.size.height;
    self.frame = frame;
    [superView addSubview:self];
}

- (void) putInCenterOf: (UIView *) superView withMargin: (CGFloat) margin {
    [self positionCenterOf:superView withMargin:margin];
    [superView addSubview:self];
}

- (void) positionCenterOf: (UIView *) superView withMargin: (CGFloat) margin {
    self.frame = CGRectMake(margin, margin, superView.frame.size.width - 2 * margin, superView.frame.size.height - 2 * margin);
}

@end
