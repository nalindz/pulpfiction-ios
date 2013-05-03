//
//  UIView+layout.h
//  BookApp
//
//  Created by Nalin on 11/15/12.
//
//

#import <UIKit/UIKit.h>

@interface UIView (LayoutUtil)

- (void)stickToBottomOf: (UIView *) superView;
- (void)putInCenterOf: (UIView *) superView withMargin: (CGFloat) margin;
- (void)positionCenterOf: (UIView *) superView withMargin: (CGFloat) margin;
- (void)putInRightEdgeOf: (UIView *) superView withMargin: (CGFloat) margin;
- (void)putInLeftEdgeOf: (UIView *) superView withMargin: (CGFloat) margin;
- (void)positionLeftOf: (UIView *) anchorView withMargin: (CGFloat) margin;
- (void)positionAbove: (UIView *) anchorView withMargin: (CGFloat) margin;
- (void)putToRightOf: (UIView *) anchorView withMargin: (CGFloat) margin;
- (void)putToLeftOf: (UIView *) anchorView withMargin: (CGFloat) margin;
- (void)putBelow: (UIView *) anchorView withMargin: (CGFloat) margin;
- (void)putInTopOf: (UIView *) superView withMargin: (CGFloat) margin;
- (void)putInBottomOf: (UIView *) superView withMargin: (CGFloat) margin;
    
@end
