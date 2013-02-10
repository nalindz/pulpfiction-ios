//
//  UIButton+ResizeWithAspectRatio.m
//  BookApp
//
//  Created by Nalin on 2/9/13.
//
//

#import "UIButton+ResizeWithAspectRatio.h"

@implementation UIButton (ResizeWithAspectRatio)

- (void)resizeHeight: (CGFloat) height {
    self.width = height / self.height  * self.width;
    self.height = height;
}

- (void)resizeWidth: (CGFloat) width {
    self.height = width / self.width  * self.height;
    self.width = width;
}

@end