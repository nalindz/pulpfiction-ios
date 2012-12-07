//
//  Block.h
//  BookApp
//
//  Created by Nalin on 11/2/12.
//
//

#import "BABlock.h"
#import "BAProtocols.h"
#import <RestKit/RestKit.h>

@interface Block : BABlock <HasRKManagedObjectMapping>
+ (Block *) blockWithStoryId:(NSNumber *) storyId blockNumber:(NSNumber *)blockNumber;
@end
