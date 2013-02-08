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
#import "History.h"

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
    
    
    
    RKObjectMapping* historyMapping = [RKObjectMapping mappingForClass:[History class]];
    [History configureMapping:historyMapping];
    [objectManager.mappingProvider addObjectMapping:historyMapping];
    [objectManager.mappingProvider setSerializationMapping:historyMapping.inverseMapping forClass:History.class];
    [objectManager.router routeClass:History.class toResourcePath:@"/history" forMethod:RKRequestMethodPOST];
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
