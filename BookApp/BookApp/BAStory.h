//
//  BAStory.h
//  BookApp
//
//  Created by Nalin on 12/16/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bookmark, User;

@interface BAStory : NSManagedObject

@property (nonatomic, retain) NSNumber * blocks_count;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * total_length;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * cover_url;
@property (nonatomic, retain) NSSet *bookmarks;
@property (nonatomic, retain) User *user;
@end

@interface BAStory (CoreDataGeneratedAccessors)

- (void)addBookmarksObject:(Bookmark *)value;
- (void)removeBookmarksObject:(Bookmark *)value;
- (void)addBookmarks:(NSSet *)values;
- (void)removeBookmarks:(NSSet *)values;

@end
