//
//  UserStat.h
//  BookApp
//
//  Created by Nalin on 4/10/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface UserStat : NSManagedObject

@property (nonatomic, retain) NSNumber * own_stories_views;
@property (nonatomic, retain) NSNumber * own_stories_bookmarks;
@property (nonatomic, retain) NSNumber * total_stories_views;
@property (nonatomic, retain) NSNumber * total_stories_bookmarks;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) User *user;

@end
