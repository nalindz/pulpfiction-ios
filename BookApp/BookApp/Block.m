
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
     @"story_id",
     nil];

    mapping.primaryKeyAttribute = @"id";
    return mapping;
}

@end
