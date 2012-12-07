//
//  Story.m
//  BookApp
//
//  Created by Nalin on 11/2/12.
//
//

#import "Story.h"

@implementation Story

+ (NSEntityDescription *)entity
{
    return [NSEntityDescription entityForName:@"BAStory" inManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription entityForName:@"BAStory" inManagedObjectContext:context];
}

+ (RKManagedObjectMapping *)configureMapping:(RKManagedObjectMapping *)mapping {
    RKObjectManager* manager = [RKObjectManager sharedManager];
    [mapping mapAttributes:
     @"id",
     @"blocks_count",
     @"total_length",
     @"created_at",
     @"updated_at",
     @"title",
     nil];

    // Map the relationships.
    [mapping mapRelationship:@"user" withMapping:[manager.mappingProvider mappingForKeyPath:@"user"]];
    
    mapping.primaryKeyAttribute = @"id";
    return mapping;
}

@end
