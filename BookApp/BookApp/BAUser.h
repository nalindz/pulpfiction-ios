//
//  BAUser.h
//  BookApp
//
//  Created by Nalin on 11/2/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BAStory;

@interface BAUser : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * facebook_id;
@property (nonatomic, retain) NSSet *stories;
@end

@interface BAUser (CoreDataGeneratedAccessors)

- (void)addStoriesObject:(BAStory *)value;
- (void)removeStoriesObject:(BAStory *)value;
- (void)addStories:(NSSet *)values;
- (void)removeStories:(NSSet *)values;

@end
