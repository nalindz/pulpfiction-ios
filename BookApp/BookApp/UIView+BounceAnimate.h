//
//  UIView+BounceAnimate.h
//  BookApp
//
//  Created by Nalin on 2/9/13.
//
//

#import <UIKit/UIKit.h>

@interface UIView (BounceAnimate)

- (void) bounceAnimateWithDuration:(NSTimeInterval) duration
                            offset: (CGFloat) offset
                           bounces: (int) bounces;
    
- (void) hideAnimateWithDuration: (NSTimeInterval) duration
                          offset: (CGFloat) offset;
@end
