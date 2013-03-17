//
//  User+Util.m
//  BookApp
//
//  Created by Nalin on 3/6/13.
//
//

#import "User+Util.h"
#import "NSNumber+BitUtil.h"

@implementation User (Util)

#define CONFIRMED_USERNAME_BIT_POSITION 0

- (BOOL)isUsernameConfirmed {
    return [self.state isBitSet:CONFIRMED_USERNAME_BIT_POSITION];
}

@end
