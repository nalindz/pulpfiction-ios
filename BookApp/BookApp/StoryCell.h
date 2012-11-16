//
//  StoryCell.h
//  BookApp
//
//  Created by Nalin on 11/13/12.
//
//

#import <UIKit/UIKit.h>
#import "Story.h"

@interface StoryCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
- (void)renderWithStory: (Story *)story indexPath: (NSIndexPath *) indexPath;
@end
