//
//  NSString+FitInLabel.m
//  BookApp
//
//  Created by Nalin on 11/10/12.
//
//

#import "NSString+FitInLabel.h"
#import <CoreText/CoreText.h>

@implementation NSString (FitInLabel)

/*
- (int)getSplitIndexWithSize:(CGSize) size andFont:(UIFont *)font
{
    int length = 1;
    int lastSpace = 1;
    NSString *cutText = [self substringToIndex:length];
    CGSize textSize = [cutText sizeWithFont:font
                          constrainedToSize:CGSizeMake(size.width,
                                                       size.height + 500)];
    while (length < self.length && textSize.height <= size.height)
    {
        NSRange range = NSMakeRange (length, 1);
        if ([[self substringWithRange:range] isEqualToString:@" "]
            || [[self substringWithRange:range] isEqualToString:@"\n"]
            || [[self substringWithRange:range] isEqualToString:@"\r"])
        {
            lastSpace = length;
        }
        length++;
        cutText = [self substringToIndex:length];
        textSize = [cutText sizeWithFont:font constrainedToSize:CGSizeMake(size.width, size.height + 500)];
    }
    cutText = nil;
    if (length == self.length && textSize.height <= size.height) lastSpace = length;
    return lastSpace;
}

*/

- (int)getSplitIndexWithSize:(CGSize) size andFont:(UIFont *)font
{
    UIFont *uiFont = font;
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)uiFont.fontName, uiFont.pointSize, NULL);
    NSDictionary *attr = [NSDictionary dictionaryWithObject:(__bridge id)ctFont forKey:(id)kCTFontAttributeName];
    CFRelease(ctFont);
    NSAttributedString *attrString  = [[NSAttributedString alloc] initWithString:self attributes:attr];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    CFRange fitRange;
    CTFramesetterSuggestFrameSizeWithConstraints(
                                                frameSetter,
                                                CFRangeMake(0, 0),
                                                NULL,
                                                CGSizeMake(size.width - 10, size.height - 20),
                                                &fitRange);
    CFRelease(frameSetter);
    CFIndex numberOfCharactersThatFit = fitRange.length;
    return numberOfCharactersThatFit;
}

@end
