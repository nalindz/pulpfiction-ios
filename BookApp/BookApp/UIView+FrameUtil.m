//
//  UIView+frameSetters.m
//  TagMe
//
//  Created by Nalin on 10/27/12.
//  Copyright (c) 2012 Tagged, Inc. All rights reserved.
//

#import "UIView+FrameUtil.h"

@implementation UIView (FrameUtil)

- (void) setHeight: (CGFloat) height {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    
}

- (void) setWidth: (CGFloat) width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void) setX: (CGFloat) x {
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void) setY: (CGFloat) y {
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

    

@end
