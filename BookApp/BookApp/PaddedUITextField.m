//
//  PaddedUITextField.m
//  BookApp
//
//  Created by Nalin on 4/24/12.
//

#import "PaddedUITextField.h"

@implementation PaddedUITextField
@synthesize topPadding, bottomPadding, leftPadding, rightPadding;

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + leftPadding, bounds.origin.y + topPadding, bounds.size.width - rightPadding, bounds.size.height - bottomPadding);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
