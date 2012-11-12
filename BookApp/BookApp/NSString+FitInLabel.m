//
//  NSString+FitInLabel.m
//  BookApp
//
//  Created by Nalin on 11/10/12.
//
//

#import "NSString+FitInLabel.h"

@implementation NSString (FitInLabel)

- (int)getSplitIndexWithFrame:(CGRect) frame andFont:(UIFont *)font
{
    int length = 1;
    int lastSpace = 1;
    NSString *cutText = [self substringToIndex:length];
    CGSize textSize = [cutText sizeWithFont:font
                          constrainedToSize:CGSizeMake(frame.size.width,
                                                       frame.size.height + 500)];
    while (length < self.length && textSize.height <= frame.size.height)
    {
        NSRange range = NSMakeRange (length, 1);
        if ([[self substringWithRange:range] isEqualToString:@" "])
        {
            lastSpace = length;
        }
        length++;
        cutText = [self substringToIndex:length];
        textSize = [cutText sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, frame.size.height + 500)];
    }
    if (length == self.length) lastSpace = length;
    return lastSpace;
}

@end
