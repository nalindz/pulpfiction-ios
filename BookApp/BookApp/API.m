//
//  API.m
//  BookApp
//
//  Created by Nalin on 11/1/12.
//
//

#import "API.h"
#import "Environment.h"
#import <RestKit/RKErrorMessage.h>
#import "Story+RestKit.h"
#import "Block+RestKit.h"
#import "User+RestKit.h"
#import "Bookmark+RestKit.h"
#import "StoryView+RestKit.h"

static API* _sharedInstance = nil;

@interface API ()
@property (strong, atomic) RKManagedObjectStore * objectStore;
- (void)createErrorMapping;
- (void)setupObjectMapping;
- (void)initRestKit;
@end

@implementation API

+ (API*)sharedInstance {
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [[self alloc] init];
        }
    } 
    return _sharedInstance;
}

- (API*)init {
    self = [super init];
    [self initRestKit];
    return self;
}

- (void)initRestKit {
    
    Environment* tierConfig = [Environment sharedInstance];
    NSString* baseUrl = [tierConfig getConfigOption:@"apiURL"];
    NSString* objectStoreFilename = [tierConfig getConfigOption:@"ObjectStoreFilename"];
    
    NSLog(@"fetch object store file name : %@", objectStoreFilename);
#if DEBUG
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
#endif
    
    NSLog(@"base url: %@", [NSURL URLWithString:baseUrl]);
    
    RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:[NSURL URLWithString:baseUrl]];
    objectManager.serializationMIMEType = RKMIMETypeJSON;
    
    [objectManager setClient:[RKClient sharedClient]];
    
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:objectStoreFilename usingSeedDatabaseName:nil managedObjectModel:[self managedObjectModel] delegate:self];
    
    self.objectStore = objectManager.objectStore;
    
    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    [self createErrorMapping];
    
    RKManagedObjectMapping* userMapping = [RKManagedObjectMapping mappingForEntityWithName:@"User"
                                                                       inManagedObjectStore:objectManager.objectStore];
    [User configureMapping:userMapping];
    [objectManager.mappingProvider registerMapping:userMapping
                                   withRootKeyPath:@"user"];
    
    
    RKManagedObjectMapping* bookmarkMapping =
    [RKManagedObjectMapping mappingForEntityWithName:@"Bookmark"
                                inManagedObjectStore:objectManager.objectStore];
    [Bookmark configureMapping:bookmarkMapping];
    [objectManager.mappingProvider registerMapping:bookmarkMapping
                                   withRootKeyPath:@"bookmark"];
    
    [objectManager.router routeClass:Bookmark.class toResourcePath:@"/bookmarks" forMethod:RKRequestMethodPOST];
    [objectManager.router routeClass:Bookmark.class toResourcePath:@"/stories/:story_id/bookmarks" forMethod:RKRequestMethodDELETE];
    
    
    RKManagedObjectMapping* storyMapping =
    [RKManagedObjectMapping mappingForEntityWithName:@"Story"
                                inManagedObjectStore:objectManager.objectStore];
    [Story configureMapping:storyMapping];
    [objectManager.mappingProvider registerMapping:storyMapping
                                   withRootKeyPath:@"story"];
    [objectManager.router routeClass:Story.class toResourcePath:@"/stories/:id" forMethod:RKRequestMethodPUT];
    
    
    RKManagedObjectMapping* blockMapping =
    [RKManagedObjectMapping mappingForEntityWithName:@"Block"
                                inManagedObjectStore:objectManager.objectStore];
    [Block configureMapping:blockMapping];
    [objectManager.mappingProvider registerMapping:blockMapping
                                   withRootKeyPath:@"block"];
    
    
    
    
    
    
    RKObjectMapping* storyViewMapping = [RKObjectMapping mappingForClass:StoryView.class];
    [StoryView configureMapping:storyViewMapping];
    [objectManager.mappingProvider addObjectMapping:storyViewMapping];
    [objectManager.mappingProvider setSerializationMapping:storyViewMapping.inverseMapping forClass:StoryView.class];
    [objectManager.router routeClass:StoryView.class toResourcePath:@"/stories/:story_id/view" forMethod:RKRequestMethodPOST];
}


- (void)setupObjectMapping {
}


- (void)createErrorMapping {
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    [errorMapping mapKeyPath:@"description" toAttribute:@"errorMessage"];

    [RKObjectManager.sharedManager.mappingProvider setErrorMapping:errorMapping];
}

- (NSManagedObjectModel *)managedObjectModel {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BookApp-Entities" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
}

@end
