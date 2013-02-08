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


@interface ProfileStoryCell : UITableViewCell
<UITextViewDelegate,
RKObjectLoaderDelegate>
@property (nonatomic, weak) ProfileViewController *delegate;
@property (nonatomic, strong) Story *story;
+ (CGFloat)cellHeight;
- (void)renderWithStory: (Story *) story;
@end
