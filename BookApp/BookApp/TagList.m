//
//  TagList.m
//  BookApp
//
//  Created by Nalin on 2/6/13.
//
//

#import "TagList.h"

@implementation TagList

- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
        self.tags = [NSMutableArray array];
    }
    return self;
}

@end
