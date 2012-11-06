#import <UIKit/UIKit.h>
#import "SlideScrollView.h"

@protocol ISColumnsControllerChild <NSObject>
@optional
- (void)didBecomeActive;
- (void)didResignActive;
@end

@interface ISColumnsController : UIViewController <UIScrollViewDelegate, SlideScrollDataSource>

@property (retain, nonatomic) NSMutableArray       *viewControllers;
@property (retain, nonatomic) SlideScrollView  *scrollView;
@property (retain, nonatomic) UILabel       *titleLabel;
@property (retain, nonatomic) UIPageControl *pageControl;
- (void)reloadChildViewControllers;

@end
