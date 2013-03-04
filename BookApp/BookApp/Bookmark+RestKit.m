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
    [bookmarkMapping addAttributeMappingsFromArray:@[
     @"id",
     @"page_number",
     @"font_size",
     @"user_id",
     @"created_at",
     @"updated_at",
     @"story_id"]];

    bookmarkMapping.identificationAttributes = @[@"id"];
    
    
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
