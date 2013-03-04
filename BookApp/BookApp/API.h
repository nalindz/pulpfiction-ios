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

@interface API : NSObject
+ (API*) sharedInstance;
@property (nonatomic, strong) User *loggedInUser;
@property (nonatomic, strong) NSMutableDictionary *mappings;
- (void)initRestKit;
@end
