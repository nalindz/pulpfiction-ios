//
//  TagList+RestKit.m
//  BookApp
//
//  Created by Nalin on 2/6/13.
//
//

#import "TagList+RestKit.h"

@implementation TagList (RestKit)

+ (RKManagedObjectMapping *)configureMapping:(RKManagedObjectMapping *)mapping {
    RKObjectManager* manager = [RKObjectManager sharedManager];
    
    [mapping mapKeyPath:@"tag" toRelationship:@"tags" withMapping:[manager.mappingProvider mappingForKeyPath:@"tag"]];
    return mapping;
}

@end
