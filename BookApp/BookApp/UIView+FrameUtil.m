//
//  UIView+frameSetters.m
//  TagMe
//
//  Created by Nalin on 10/27/12.
//  Copyright (c) 2012 Tagged, Inc. All rights reserved.
//

#import "UIView+FrameUtil.h"

@implementation UIView (FrameUtil)

- (void) setHeight: (int) height {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    
}

- (void) setWidth: (int) width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void) setX: (int) x {
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void) setY: (int) y {
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (int)height {
    return self.frame.size.height;
}

- (int)width {
    return self.frame.size.width;
}

- (int)y {
    return self.frame.origin.y;
}

- (int)x {
    return self.frame.origin.x;
}

    

@end
