#import <UIKit/UIKit.h>
#import "PageCell.h"
#import "Story.h"
#import "PageView.h"

@protocol ReadViewControllerDelegate
- (void)deleteBookmarkedStory: (Story *)bookmarkedStory;
@end

@interface ReadViewController : UIViewController
<UIScrollViewDelegate,
SlideViewCellDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (retain, nonatomic) NSMutableArray *viewControllers;
@property (retain, nonatomic) PageView *scrollView;
@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UIPageControl *pageControl;
@property (retain, nonatomic) Story * story;
@property (retain, nonatomic) NSNumber * storyId;
@property (nonatomic, retain) NSNumber *startingPageNumber;
@property (nonatomic, weak) id<ReadViewControllerDelegate> delegate;

@end
