//
//  UserStat+RestKit.m
//  BookApp
//
//  Created by Nalin on 4/10/13.
//
//

#import "UserStat+RestKit.h"

@implementation UserStat (RestKit)

+ (void)configureRestKitMapping {
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    RKEntityMapping* userStatMapping =
    [RKEntityMapping mappingForEntityForName:@"UserStat"
                            inManagedObjectStore:objectManager.managedObjectStore];
    
    NSArray *userStatMappingArray =
   @[@"id",
     @"user_id",
     @"own_stories_bookmarks",
     @"own_stories_views",
     @"total_stories_views",
     @"total_stories_bookmarks"];
    
    [userStatMapping addAttributeMappingsFromArray:userStatMappingArray];
    
    userStatMapping.identificationAttributes = @[@"id"];
    [API sharedInstance].mappings[@"userStat"] = userStatMapping;
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:userStatMappingArray];
    
    [objectManager addRequestDescriptor:
     [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                           objectClass:[UserStat class]
                                           rootKeyPath:@"user_stat"]];
    
}

@end
