//
//  UIView+BounceAnimate.m
//  BookApp
//
//  Created by Nalin on 2/9/13.
//
//

#import "UIView+BounceAnimate.h"
#import "UIView+FrameUtil.h"

@interface UIView()
@end

@implementation UIView (BounceAnimate)


- (void) hideAnimateWithDuration: (NSTimeInterval) duration
                          offset: (CGFloat) offset {
    CGFloat originalY = self.y;
    if (self.hidden) return;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0.0;
        self.y = self.y - offset;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.y = originalY;
    }];
}


- (void) bounceAnimateWithDuration:(NSTimeInterval) duration
                            offset: (CGFloat) offset
                           bounces: (int) bounces{
    
    
    if (!self.hidden) return;
    
    CGFloat originalY = self.y;
    self.y = self.y - offset;
    self.alpha = 0.0;
    self.hidden = NO;
    
    [self animateWithDuration:duration offset:(offset * 1.8) bounces:bounces originalY:originalY];
    
}

- (void)animateWithDuration:(NSTimeInterval) duration
                            offset: (CGFloat) offset
                    bounces: (int) bounces
                  originalY: (int) originalY {
    
    __block int _bounces = bounces;
    __block CGFloat _offset = offset;
    __block NSTimeInterval _duration = duration;
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.alpha = 1.0;
                         _offset = _offset * 0.8;
                         self.y = self.y + _offset;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:(_duration = (_duration * 0.8))
                                          animations:^{
                                              _offset = _offset * 0.8;
                                              self.y = self.y - _offset;
                                              _bounces -= 1;
                                          } completion:^(BOOL finished) {
                                              if (_bounces > 0) {
                                                  [self animateWithDuration:_duration
                                                                     offset:_offset
                                                                    bounces:_bounces
                                                                  originalY:originalY];
                                              } else {
                                                  [UIView animateWithDuration:_duration animations:^{
                                                      self.y = originalY;
                                                  }];
                                              }
                                          }
                          ];
                     }];
}

@end
