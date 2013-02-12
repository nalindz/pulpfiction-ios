#import <UIKit/UIKit.h>
#import "SlideScrollView.h"
#import "SlideViewCell.h"
#import "Story.h"
#import "PageView.h"

@protocol ISColumnsControllerChild <NSObject>
@optional
- (void)didBecomeActive;
- (void)didResignActive;
@end

@interface ReadViewController : UIViewController
<UIScrollViewDelegate,
SlideScrollDataSource,
SlideViewCellDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
RKObjectLoaderDelegate
>

@property (retain, nonatomic) NSMutableArray       *viewControllers;
@property (retain, nonatomic) PageView  *scrollView;
@property (retain, nonatomic) UILabel       *titleLabel;
@property (retain, nonatomic) UIPageControl *pageControl;
@property (retain, nonatomic)Story * story;
@property (nonatomic, retain) NSNumber *startingPageNumber;
- (void)reloadChildViewControllers;


@end
