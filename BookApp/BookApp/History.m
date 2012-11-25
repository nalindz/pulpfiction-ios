//
//  History.m
//  BookApp
//
//  Created by Nalin on 11/24/12.
//
//

#import "History.h"

@implementation History

+ (RKManagedObjectMapping *)configureMapping:(RKManagedObjectMapping *)mapping {
    [mapping mapAttributes:
     @"story_id",
     nil];
    return mapping;
}

@end
