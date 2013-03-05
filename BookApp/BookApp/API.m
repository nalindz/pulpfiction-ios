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
#import <RestKit/RKErrorMessage.h>


static API* _sharedInstance = nil;

@interface API ()
@property (nonatomic, strong) NSNumber *loggedInUserId;
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

- (NSMutableDictionary*) mappings {
    if (_mappings == nil) {
        _mappings = [NSMutableDictionary dictionary];
    }
    return _mappings;
}

- (User *)loggedInUser {
    return [User findFirstByAttribute:@"id" withValue:self.loggedInUserId];
}

- (void)setLoggedInUser:(User *)loggedInUser {
    self.loggedInUserId = loggedInUser.id;
}

- (API*)init {
    self = [super init];
    return self;
}

- (void)initRestKit {
    Environment* tierConfig = [Environment sharedInstance];
    NSString* baseUrl = [tierConfig getConfigOption:@"apiURL"];
#if DEBUG
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
#endif
    
    NSLog(@"base url: %@", [NSURL URLWithString:baseUrl]);
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:baseUrl]];
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"BookApp-Entities" ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSError *error;
    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
    if (! success) {
        RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
    }
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Store.sqlite"];
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    if (! persistentStore) {
        RKLogError(@"Failed adding persistent store: %@", error);
    }
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Store.sqlite"];
    [managedObjectStore createManagedObjectContexts];
    objectManager.managedObjectStore = managedObjectStore;
    
    
    // Enable automatic network activity indicator management
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [self createErrorMapping];
    
    [User configureRestKitMapping];
    [Bookmark configureRestKitMapping];
    [Story configureRestKitMapping];
    [Block configureRestKitMapping];
    [StoryView configureRestKitMapping];
}


- (void)createErrorMapping {
    
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"description"     toKeyPath:@"errorMessage"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError);
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping pathPattern:nil keyPath:@"error" statusCodes:statusCodes];
    [RKObjectManager.sharedManager addResponseDescriptor:errorDescriptor];


    /*
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    [errorMapping mapKeyPath:@"description" toAttribute:@"errorMessage"];
    [RKObjectManager.sharedManager.mappingProvider setErrorMapping:errorMapping];
     */
}

- (NSManagedObjectModel *)managedObjectModel {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BookApp-Entities" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
}

@end
