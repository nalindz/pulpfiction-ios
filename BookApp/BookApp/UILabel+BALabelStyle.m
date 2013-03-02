//
//  UILabel+BALabelStyle.m
//  BookApp
//
//  Created by Nalin on 3/1/13.
//
//

#import "UILabel+BALabelStyle.h"

@implementation UILabel (BALabelStyle)
- (id)initWithBAStyle {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.textColor = [UIColor darkGrayColor];
    }
    return self;
}

@end
