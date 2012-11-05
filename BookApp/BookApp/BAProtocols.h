//
//  BAProtocols.h
//
//  Created by Nalin on 8/14/12.
//  Copyright (c) 2012 Tagged, Inc. All rights reserved.
//

#import <RestKit/RestKit.h>

@protocol HasRKObjectMapping <NSObject>

+ (RKObjectMapping*) configureMapping:(RKObjectMapping*)mapping;

@end

@protocol HasRKManagedObjectMapping <HasRKObjectMapping>

+ (RKManagedObjectMapping*) configureMapping:(RKManagedObjectMapping*)mapping;

@end
