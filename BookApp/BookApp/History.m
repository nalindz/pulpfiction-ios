//
//  History.m
//  BookApp
//
//  Created by Nalin on 11/24/12.
//
//

#import "History.h"

@implementation History

+ (RKObjectMapping *)configureMapping:(RKObjectMapping *)mapping {
    [mapping mapAttributes:
     @"story_id",
     nil];
    return mapping;
}

@end
