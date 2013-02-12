//
//  Bookmark+RestKit.m
//  BookApp
//
//  Created by Nalin on 2/11/13.
//
//

#import "Bookmark+RestKit.h"

@implementation Bookmark (RestKit)

+ (RKManagedObjectMapping *)configureMapping:(RKManagedObjectMapping *)mapping {
    [mapping mapAttributes:
     @"id",
     @"page_number",
     @"font_size",
     @"created_at",
     @"updated_at",
     @"story_id",
     nil];

    mapping.primaryKeyAttribute = @"id";
    return mapping;
}

@end
