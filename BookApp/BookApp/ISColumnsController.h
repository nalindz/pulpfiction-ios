#import <UIKit/UIKit.h>
#import "SlideScrollView.h"
#import "SlideViewCell.h"
#import "Story.h"

@protocol ISColumnsControllerChild <NSObject>
@optional
- (void)didBecomeActive;
- (void)didResignActive;
@end

@interface ISColumnsController : UIViewController
<UIScrollViewDelegate,
SlideScrollDataSource,
SlideViewCellDelegate,
RKObjectLoaderDelegate
>

@property (retain, nonatomic) NSMutableArray       *viewControllers;
@property (retain, nonatomic) SlideScrollView  *scrollView;
@property (retain, nonatomic) UILabel       *titleLabel;
@property (retain, nonatomic) UIPageControl *pageControl;
@property (retain, nonatomic)Story * story;
@property (nonatomic, retain) NSNumber *startingPageNumber;
- (void)reloadChildViewControllers;

@end
