//
//  ProfileStoryCell.h
//  BookApp
//
//  Created by Nalin on 2/2/13.
//
//

#import <UIKit/UIKit.h>
#import "Story.h"
#import "ProfileViewController.h"


@interface ProfileStoryCell : UITableViewCell <UITextViewDelegate>
@property (nonatomic, weak) ProfileViewController *delegate;
+ (CGFloat)cellHeight;
- (void)renderWithStory: (Story *) story;
@end
