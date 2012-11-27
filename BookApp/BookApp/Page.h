//
//  Page.h
//  BookApp
//
//  Created by Nalin on 11/11/12.
//
//

#import "BAPage.h"

@interface Page : BAPage
- (Page *) unfault;
- (BOOL)isLastPage;
+ (Page *)pageWithNumber: (NSNumber *)pageNumber storyId: (NSNumber *) storyId;
@end
