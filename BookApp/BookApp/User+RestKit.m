//
//  User+RestKit.m
//  BookApp
//

#import "User+RestKit.h"

@implementation User(RestKit)

+ (void)configureRestKitMapping {
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    RKEntityMapping* userMapping =
    [RKEntityMapping mappingForEntityForName:@"User"
                            inManagedObjectStore:objectManager.managedObjectStore];
    
    NSArray *userMappingArray =
   @[@"id",
     @"username",
     @"first_name",
     @"last_name",
     @"email",
     @"state",
     @"facebook_id"];
    
    [userMapping addAttributeMappingsFromArray:userMappingArray];
    
    userMapping.identificationAttributes = @[@"id"];
    [API sharedInstance].mappings[@"user"] = userMapping;
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:userMappingArray];
    
    [objectManager addRequestDescriptor:
     [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                           objectClass:[User class]
                                           rootKeyPath:@"user"]];
    
    
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    [objectManager addResponseDescriptor:
     [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                             pathPattern:@"/login"
                                                 keyPath:@"user"
                                             statusCodes:statusCodes]];
    
    [objectManager addResponseDescriptor:
     [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                             pathPattern:@"/users/:id"
                                                 keyPath:@"user"
                                             statusCodes:statusCodes]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[User class]
                                             pathPattern:@"/login"
                                             method:RKRequestMethodPOST]];
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[User class]
                                             pathPattern:@"/users/:id"
                                             method:RKRequestMethodPUT]];
}

@end