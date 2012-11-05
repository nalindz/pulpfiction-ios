//
//  Environment.m
//  TagMe
//
//  Created by Nalin on 8/14/12.
//  Copyright (c) 2012 Tagged, Inc. All rights reserved.
//

#import "Environment.h"

@implementation Environment

static Environment* sharedInstance = nil;

@synthesize environmentConfig = _environmentConfig;
@synthesize configuration;

- (void) initializeSharedInstance {
    self.configuration = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Configuration"];
    NSLog(@"Configuration: %@", self.configuration);
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* envsPListPath = [bundle pathForResource:@"Environments" ofType:@"plist"];
    NSDictionary* environments = [[NSDictionary alloc] initWithContentsOfFile:envsPListPath];
    NSDictionary* environment = [environments objectForKey:self.configuration];

    if(environment){
        NSLog(@"Loading %@ environment configuration", self.configuration);
        self.environmentConfig = environment;
    }
}

+ (Environment*) sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
            [sharedInstance initializeSharedInstance];
        }
        return sharedInstance;
    }
}

- (id) getConfigOption:(NSString*) prefKey {
    return [self.environmentConfig objectForKey:prefKey];
}

@end
