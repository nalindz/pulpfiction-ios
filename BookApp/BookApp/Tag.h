//
//  Tag.h
//  BookApp
//
//  Created by Nalin on 2/7/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Story;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSNumber * story_id;
@property (nonatomic, retain) Story *story;

@end
