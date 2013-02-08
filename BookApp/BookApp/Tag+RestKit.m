//
//  Tag+RestKit.m
//  BookApp
//
//  Created by Nalin on 2/6/13.
//
//

#import "Tag+RestKit.h"

@implementation Tag (RestKit)

+ (RKManagedObjectMapping *)configureMapping:(RKManagedObjectMapping *)mapping {
    [mapping mapAttributes:
     @"id",
     @"text",
     @"story_id",
     @"created_at",
     @"updated_at",
     nil];

    mapping.primaryKeyAttribute = @"id";
    return mapping;
}

@end
