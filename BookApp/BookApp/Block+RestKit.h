//
//  Block.h
//  BookApp
//
//  Created by Nalin on 11/2/12.
//
//

#import "BAProtocols.h"
#import "Block.h"

@interface Block(RestKit) <HasRestKitMapping>
+ (Block *) blockWithStoryId:(NSNumber *) storyId blockNumber:(NSNumber *)blockNumber;
@end
