//
//  BAPage.h
//  BookApp
//
//  Created by Nalin on 11/11/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BAPage : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * page_number;
@property (nonatomic, retain) NSNumber * first_block_number;
@property (nonatomic, retain) NSNumber * first_block_index;
@property (nonatomic, retain) NSNumber * last_block_index;
@property (nonatomic, retain) NSNumber * last_block_number;
@property (nonatomic, retain) NSNumber * story_id;

@end
