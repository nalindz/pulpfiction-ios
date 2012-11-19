//
//  BAStory.h
//  BookApp
//
//  Created by Nalin on 11/18/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BABookmark, User;

@interface BAStory : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *bookmarks;
@end

@interface BAStory (CoreDataGeneratedAccessors)

- (void)addBookmarksObject:(BABookmark *)value;
- (void)removeBookmarksObject:(BABookmark *)value;
- (void)addBookmarks:(NSSet *)values;
- (void)removeBookmarks:(NSSet *)values;

@end
