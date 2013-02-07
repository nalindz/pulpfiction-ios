//
//  User.m
//  BookApp
//
//  Created by Haochen Li on 2012-11-25.
//
//

#import "User.h"

@implementation User(RestKit)

+ (RKManagedObjectMapping *)configureMapping:(RKManagedObjectMapping *)mapping {
    [mapping mapAttributes:
     @"id",
     @"first_name",
     @"last_name",
     @"email",
     @"facebook_id",
     nil];
    
    mapping.primaryKeyAttribute = @"id";
    return mapping;
}

@end
