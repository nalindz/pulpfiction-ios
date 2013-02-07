//
//  Page+RestKit.h
//  BookApp
//
//  Created by Nalin on 11/11/12.
//
//

#import "Page.h"
@interface Page(RestKit)
- (Page *) unfault;
- (BOOL)isLastPage;
+ (Page *)pageWithNumber: (NSNumber *)pageNumber storyId: (NSNumber *) storyId;
@end
