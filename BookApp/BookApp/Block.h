//
//  Block.h
//  BookApp
//
//  Created by Nalin on 2/6/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Block : NSManagedObject

@property (nonatomic, retain) NSNumber * block_number;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * first_block;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * last_block;
@property (nonatomic, retain) NSNumber * story_id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * total_start_index;
@property (nonatomic, retain) NSDate * updated_at;

@end
