//
//  NSNumber+BitUtil.m
//  BookApp
//
//  Created by Nalin on 3/6/13.
//
//

#import "NSNumber+BitUtil.h"

@implementation NSNumber (BitUtil)

- (BOOL)isBitSet: (int) bitPosition {
    return (1 << bitPosition) & [self intValue];
}

- (NSNumber *)setBit:(BOOL) bitValue atPosition: (int) bitPosition {
    if (bitValue) {
        return @([self intValue] | (1 << bitPosition));
    } else {
        return @([self intValue] & ~(1 << bitPosition));
    }
}

@end
