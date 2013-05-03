//
//  UILabel+AutoSize.m
//  BookApp
//
//  Created by Nalin on 11/15/12.
//
//

#import "UILabel+AutoSize.h"

@implementation UILabel (AutoSize)

- (void)setText:(NSString *)text fixedWidth:(BOOL) fixedWidth {
    
    CGSize expectedSize;
    CGRect newFrame = self.frame;
    if (fixedWidth) {
     expectedSize = [text sizeWithFont:self.font
                           constrainedToSize:CGSizeMake(self.frame.size.width, 9999)
                               lineBreakMode:self.lineBreakMode];
        newFrame.size.height = expectedSize.height;
    } else {
         expectedSize = [text sizeWithFont:self.font 
                               constrainedToSize:CGSizeMake(9999, self.frame.size.height)
                                   lineBreakMode:self.lineBreakMode];
        newFrame.size.width = expectedSize.width;
    }
    
    self.frame = newFrame;    
    self.text = text;
}

- (void)autoSizeWithText:(NSString *) text {
    [self setText:text fixedWidth:NO];
    [self setText:text fixedWidth:YES];
}
    
@end
