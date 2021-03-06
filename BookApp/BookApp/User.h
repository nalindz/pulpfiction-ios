//
//  User.h
//  BookApp
//
//  Created by Nalin on 4/10/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bookmark, Story, UserStat;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * email_hash;
@property (nonatomic, retain) NSString * facebook_id;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *bookmarks;
@property (nonatomic, retain) NSSet *stories;
@property (nonatomic, retain) UserStat *stat;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addBookmarksObject:(Bookmark *)value;
- (void)removeBookmarksObject:(Bookmark *)value;
- (void)addBookmarks:(NSSet *)values;
- (void)removeBookmarks:(NSSet *)values;

- (void)addStoriesObject:(Story *)value;
- (void)removeStoriesObject:(Story *)value;
- (void)addStories:(NSSet *)values;
- (void)removeStories:(NSSet *)values;

@end
