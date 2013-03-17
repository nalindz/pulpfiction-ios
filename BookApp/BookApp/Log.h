//
//  Log.h
//  BookApp
//
//  Created by Nalin on 3/7/13.
//
//

#import <Foundation/Foundation.h>

@interface Log : NSObject
+ (void) eventName: (NSString *) eventName data: (NSDictionary *) data;
@end
