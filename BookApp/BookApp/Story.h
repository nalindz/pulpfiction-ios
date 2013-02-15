//
//  Story.h
//  BookApp
//
//  Created by Nalin on 2/13/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bookmark, User;

@interface Story : NSManagedObject

@property (nonatomic, retain) NSNumber * blocks_count;
@property (nonatomic, retain) NSString * cover_url;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * total_length;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * views_count;
@property (nonatomic, retain) Bookmark *bookmark;
@property (nonatomic, retain) User *user;

@end
