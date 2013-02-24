//
//  API.h
//  BookApp
//
//  Created by Nalin on 11/1/12.
//
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "User.h"

@interface API : NSObject <RKManagedObjectStoreDelegate>
+ (API*) sharedInstance;
@property (nonatomic, strong) User *loggedInUser;
@end
