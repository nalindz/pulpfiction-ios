//
//  BABlock.h
//  BookApp
//
//  Created by Nalin on 11/2/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BABlock : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * block_number;
@property (nonatomic, retain) NSNumber * story_id;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;

@end
