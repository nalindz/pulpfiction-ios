//
//  UIButton+AutoSizeWithImage.m
//  BookApp
//
//  Created by Nalin on 11/18/12.
//
//

#import "UIButton+AutoSize.h"

@implementation UIButton (AutoSize)

- (void)autoSizeWithImage: (NSString *) imageName {
    UIImageView *tmpImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self.height = tmpImage.height;
    self.width = tmpImage.height;
    [self setImage:tmpImage.image forState:UIControlStateNormal];
}

- (void) autoSizeWithText: (NSString *) text fixedWidth: (BOOL) fixedWidth {
    CGSize expectedSize;
    CGRect newFrame = self.frame;
    if (fixedWidth) {
     expectedSize = [text sizeWithFont:self.titleLabel.font
                           constrainedToSize:CGSizeMake(self.frame.size.width, 9999)
                               lineBreakMode:self.titleLabel.lineBreakMode];
        newFrame.size.height = expectedSize.height;
    } else {
         expectedSize = [text sizeWithFont:self.titleLabel.font
                               constrainedToSize:CGSizeMake(9999, self.frame.size.height)
                                   lineBreakMode:self.titleLabel.lineBreakMode];
        newFrame.size.width = expectedSize.width;
    }
    
    self.frame = newFrame;    
    [self setTitle:text forState:UIControlStateNormal];
}


@end
