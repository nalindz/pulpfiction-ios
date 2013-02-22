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
- (void)renderWithStory: (Story *)story indexPath: (NSIndexPath *) indexPath;
@end
