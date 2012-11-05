//
//  Environment.h
//  TagMe
//
//  Created by Nalin on 8/14/12.
//  Copyright (c) 2012 Tagged, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Environment : NSObject

+ (Environment*) sharedInstance;

- (id) getConfigOption:(NSString*) prefKey;


@property (nonatomic, strong) NSDictionary* environmentConfig;
@property (nonatomic, strong) NSString* configuration;
@end