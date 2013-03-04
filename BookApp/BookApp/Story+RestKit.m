//
//  Story.m
//  BookApp
//
//  Created by Nalin on 11/2/12.
//
//

#import "Story+RestKit.h"

@implementation Story(RestKit)
+ (void)configureRestKitMapping {
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    RKEntityMapping* storyMapping =
    [RKEntityMapping mappingForEntityForName:@"Story"
                            inManagedObjectStore:objectManager.managedObjectStore];
    
    [API sharedInstance].mappings[@"story"] = storyMapping;
    
    [storyMapping addAttributeMappingsFromArray:@[
     @"id",
     @"blocks_count",
     @"total_length",
     @"created_at",
     @"updated_at",
     @"cover_url",
     @"views_count",
     @"title",
     @"tags"]];
    
    storyMapping.identificationAttributes = @[@"id"];
    
    
    // Map the relationships.
     RKRelationshipMapping *userRelationship =
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                 toKeyPath:@"user"
                                               withMapping:[API sharedInstance].mappings[@"user"]];
    
    
     RKRelationshipMapping *bookmarkRelationship =
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"bookmark"
                                                 toKeyPath:@"bookmark"
                                               withMapping:[API sharedInstance].mappings[@"bookmark"]];
    
    [storyMapping addPropertyMappingsFromArray:
     @[userRelationship, bookmarkRelationship]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[Story class]
                                             pathPattern:@"/stories/:id"
                                             method:RKRequestMethodPUT]];
    
    
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    [objectManager addResponseDescriptor:
     [RKResponseDescriptor responseDescriptorWithMapping:storyMapping
                                             pathPattern:@"/stories"
                                                 keyPath:@"story"
                                             statusCodes:statusCodes]];
    
}

@end
