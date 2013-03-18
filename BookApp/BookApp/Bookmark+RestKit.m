//
//  Bookmark+RestKit.m
//  BookApp
//
//  Created by Nalin on 2/11/13.
//
//

#import "Bookmark+RestKit.h"

@implementation Bookmark (RestKit)

+ (void)configureRestKitMapping {
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    RKEntityMapping* bookmarkMapping =
    [RKEntityMapping mappingForEntityForName:@"Bookmark"
                            inManagedObjectStore:objectManager.managedObjectStore];
    
    [API sharedInstance].mappings[@"bookmark"] = bookmarkMapping;
    
    NSArray *bookmarkMappingArray =@[
     @"id",
     @"page_number",
     @"font_size",
     @"user_id",
     @"created_at",
     @"updated_at",
     @"story_id"];
    
    
    
    [bookmarkMapping addAttributeMappingsFromArray:bookmarkMappingArray];

    bookmarkMapping.identificationAttributes = @[@"id"];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:bookmarkMappingArray];
    
    [objectManager addRequestDescriptor:
     [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                           objectClass:[Bookmark class]
                                           rootKeyPath:@"bookmark"]];
    
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[Bookmark class]
                                             pathPattern:@"/stories/:story_id/bookmarks"
                                             method:RKRequestMethodPOST]];
    
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[Bookmark class]
                                             pathPattern:@"/stories/:story_id/bookmarks"
                                             method:RKRequestMethodDELETE]];
    
}

@end
