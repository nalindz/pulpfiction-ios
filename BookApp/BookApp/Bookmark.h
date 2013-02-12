//
//  Bookmark.h
//  BookApp
//
//  Created by Nalin on 2/11/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Page, Story, User;

@interface Bookmark : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * font_size;
@property (nonatomic, retain) NSNumber * story_id;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * page_number;
@property (nonatomic, retain) Page *page;
@property (nonatomic, retain) Story *story;
@property (nonatomic, retain) User *user;

@end
