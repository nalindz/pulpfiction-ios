//
//  UIFont+BAFont.m
//  BookApp
//
//  Created by Nalin on 2/3/13.
//
//

#import "UIFont+BAFont.h"

@implementation UIFont (BAFont)

+ (UIFont *) h3 {
    return [UIFont fontWithName:@"MetaBoldLF-Roman" size:26];
}

+ (UIFont *) h2 {
    return [UIFont fontWithName:@"MetaBoldLF-Roman" size:30];
}

+ (UIFont *) h1 {
    return [UIFont fontWithName:@"MetaBoldLF-Roman" size:40];
}

@end