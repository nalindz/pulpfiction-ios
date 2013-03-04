
//
//  Block.m
//  BookApp
//
//  Created by Nalin on 11/2/12.
//
//

#import "Block+RestKit.h"

@implementation Block(RestKit)

+ (void)configureRestKitMapping {
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    RKEntityMapping* blockMapping =
    [RKEntityMapping mappingForEntityForName:@"Block"
                            inManagedObjectStore:objectManager.managedObjectStore];
    
    [API sharedInstance].mappings[@"block"] = blockMapping;
    
    [blockMapping addAttributeMappingsFromArray:@[
     @"id",
     @"text",
     @"block_number",
     @"total_start_index",
     @"story_id",
     @"first_block",
     @"last_block"]];

    blockMapping.identificationAttributes = @[@"id"];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    [objectManager addResponseDescriptor:
     [RKResponseDescriptor responseDescriptorWithMapping:blockMapping
                                             pathPattern:@"/blocks"
                                                 keyPath:@"block"
                                             statusCodes:statusCodes]];
}

+ (Block *) blockWithStoryId:(NSNumber *) storyId blockNumber:(NSNumber *)blockNumber {
    return [Block findFirstWithPredicate:[NSPredicate predicateWithFormat:@"block_number == %@ AND story_id == %@", blockNumber, storyId]];
}


@end
