//
//  BABookmark.h
//  BookApp
//
//  Created by Nalin on 11/18/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Page, Story, User;

@interface BABookmark : NSManagedObject

@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSNumber * page_id;
@property (nonatomic, retain) NSNumber * story_id;
@property (nonatomic, retain) NSNumber * auto_bookmark;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Page *page;
@property (nonatomic, retain) Story *story;

@end
