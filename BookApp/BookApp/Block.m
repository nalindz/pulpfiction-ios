
//
//  Block.m
//  BookApp
//
//  Created by Nalin on 11/2/12.
//
//

#import "Block.h"

@implementation Block

+ (NSEntityDescription *)entity
{
    return [NSEntityDescription entityForName:@"BABlock" inManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription entityForName:@"BABlock" inManagedObjectContext:context];
}

+ (RKManagedObjectMapping *)configureMapping:(RKManagedObjectMapping *)mapping {
    [mapping mapAttributes:
     @"id",
     @"text",
     @"block_number",
     @"total_start_index",
     @"story_id",
     @"first_block",
     @"last_block",
     nil];

    mapping.primaryKeyAttribute = @"id";
    return mapping;
}

+ (Block *) blockWithStoryId:(NSNumber *) storyId blockNumber:(NSNumber *)blockNumber {
    return [Block findFirstWithPredicate:[NSPredicate predicateWithFormat:@"block_number == %@ AND story_id == %@", blockNumber, storyId]];
}


@end
