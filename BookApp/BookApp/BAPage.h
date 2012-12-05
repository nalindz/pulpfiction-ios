//
//  BAPage.h
//  BookApp
//
//  Created by Nalin on 12/5/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bookmark;

@interface BAPage : NSManagedObject

@property (nonatomic, retain) NSNumber * first_block_index;
@property (nonatomic, retain) NSNumber * first_block_number;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * last_block_index;
@property (nonatomic, retain) NSNumber * last_block_number;
@property (nonatomic, retain) NSNumber * page_number;
@property (nonatomic, retain) NSNumber * story_id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * font_size;
@property (nonatomic, retain) NSSet *bookmarks;
@end

@interface BAPage (CoreDataGeneratedAccessors)

- (void)addBookmarksObject:(Bookmark *)value;
- (void)removeBookmarksObject:(Bookmark *)value;
- (void)addBookmarks:(NSSet *)values;
- (void)removeBookmarks:(NSSet *)values;

@end
