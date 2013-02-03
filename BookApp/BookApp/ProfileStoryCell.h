//
//  ProfileStoryCell.h
//  BookApp
//
//  Created by Nalin on 2/2/13.
//
//

#import <UIKit/UIKit.h>
#import "Story.h"

@interface ProfileStoryCell : UITableViewCell
+ (CGFloat)cellHeight;
- (void)renderWithStory: (Story *) story;
@end
