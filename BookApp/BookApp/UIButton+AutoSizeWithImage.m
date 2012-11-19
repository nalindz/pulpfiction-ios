//
//  UIButton+AutoSizeWithImage.m
//  BookApp
//
//  Created by Nalin on 11/18/12.
//
//

#import "UIButton+AutoSizeWithImage.h"

@implementation UIButton (AutoSizeWithImage)

- (void)autoSizeWithImage: (NSString *) imageName {
    UIImageView *tmpImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self.height = tmpImage.height;
    self.width = tmpImage.height;
    [self setImage:tmpImage.image forState:UIControlStateNormal];
}

@end
