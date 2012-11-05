//
//  BAStory.h
//  BookApp
//
//  Created by Nalin on 11/2/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BAStory : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSManagedObject *user;

@end
