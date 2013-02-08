//
//  Story.h
//  BookApp
//
//  Created by Nalin on 2/7/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bookmark, Tag, User;

@interface Story : NSManagedObject

@property (nonatomic, retain) NSNumber * blocks_count;
@property (nonatomic, retain) NSString * cover_url;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * total_length;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSSet *bookmarks;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Story (CoreDataGeneratedAccessors)

- (void)addBookmarksObject:(Bookmark *)value;
- (void)removeBookmarksObject:(Bookmark *)value;
- (void)addBookmarks:(NSSet *)values;
- (void)removeBookmarks:(NSSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
