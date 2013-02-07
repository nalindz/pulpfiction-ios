//
//  Page.m
//  BookApp
//
//  Created by Nalin on 11/11/12.
//
//

#import "Page.h"
#import "Block.h"

@implementation Page(RestKit)


- (Page *) unfault {
    Page *retrievedPage = (Page *)[[Page currentContext] objectWithID:self.objectID];
    Page *unfaultedPage = [Page findFirstWithPredicate:[NSPredicate predicateWithFormat:@"page_number == %@ AND story_id == %@", retrievedPage.page_number, retrievedPage.story_id]];
    return unfaultedPage;
}

- (BOOL)isLastPage {
    Block *lastBlock = [Block findFirstWithPredicate:[NSPredicate predicateWithFormat:@"block_number == %@ AND story_id == %@", self.last_block_number , self.story_id]];
    
    NSLog(@"page number : %@", self.page_number);
    NSLog(@"last block: %@", lastBlock.last_block);
    NSLog(@"last block index: %@", self.last_block_index);
    NSLog(@"last block tex length: %d", lastBlock.text.length);
    
    return (lastBlock.last_block && [self.last_block_index intValue] == lastBlock.text.length);
}

+ (Page *)pageWithNumber: (NSNumber *)pageNumber storyId: (NSNumber *) storyId {
    return [Page findFirstWithPredicate:[NSPredicate predicateWithFormat:@"page_number == %@ AND story_id == %@", pageNumber, storyId]];
    
}


@end
