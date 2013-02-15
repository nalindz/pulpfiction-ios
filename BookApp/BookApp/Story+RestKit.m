//
//  Story.m
//  BookApp
//
//  Created by Nalin on 11/2/12.
//
//

#import "Story+RestKit.h"

@implementation Story(RestKit)
+ (RKManagedObjectMapping *)configureMapping:(RKManagedObjectMapping *)mapping {
    RKObjectManager* manager = [RKObjectManager sharedManager];
    [mapping mapAttributes:
     @"id",
     @"blocks_count",
     @"total_length",
     @"created_at",
     @"updated_at",
     @"cover_url",
     @"views_count",
     @"title",
     @"tags",
     nil];

    // Map the relationships.
    [mapping mapRelationship:@"user" withMapping:[manager.mappingProvider mappingForKeyPath:@"user"]];
    [mapping mapRelationship:@"bookmark" withMapping:[manager.mappingProvider mappingForKeyPath:@"bookmark"]];
    
    mapping.primaryKeyAttribute = @"id";
    return mapping;
}

@end
