//
//  UIFont+BAFont.m
//  BookApp
//
//  Created by Nalin on 2/3/13.
//
//

#import "UIFont+BAFont.h"

@implementation UIFont (BAFont)

+ (UIFont *) h6 {
    return [UIFont fontWithName:@"MetaBoldLF-Roman" size:14];
}

+ (UIFont *) h5 {
    return [UIFont fontWithName:@"MetaBoldLF-Roman" size:16];
}

+ (UIFont *) h4 {
    return [UIFont fontWithName:@"MetaBoldLF-Roman" size:20];
}

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
