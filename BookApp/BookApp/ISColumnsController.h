#import <UIKit/UIKit.h>

@protocol ISColumnsControllerChild <NSObject>
@optional
- (void)didBecomeActive;
- (void)didResignActive;
@end

@interface ISColumnsController : UIViewController <UIScrollViewDelegate>

@property (retain, nonatomic) NSMutableArray       *viewControllers;
@property (retain, nonatomic) UIScrollView  *scrollView;
@property (retain, nonatomic) UILabel       *titleLabel;
@property (retain, nonatomic) UIPageControl *pageControl;

@end
