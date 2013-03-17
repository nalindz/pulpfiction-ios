//
//  NSNumber+BitUtil.h
//  BookApp
//
//  Created by Nalin on 3/6/13.
//
//

#import <Foundation/Foundation.h>

@interface NSNumber (BitUtil)
- (BOOL)isBitSet: (int) bitPosition;
- (NSNumber *)setBit:(BOOL) bitValue atPosition: (int) bitPosition;
@end
