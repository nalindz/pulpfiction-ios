//
//  NSNumber+ToString.m
//  BookApp
//
//  Created by Nalin on 4/10/13.
//
//

#import "NSNumber+ToString.h"

@implementation NSNumber (ToString)

- (NSString *)toString {
    return [NSString stringWithFormat:@"%@", self];
}

@end
