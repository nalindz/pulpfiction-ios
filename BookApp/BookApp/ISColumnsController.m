#import "ISColumnsController.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@interface ISColumnsController ()

- (void)reloadChildViewControllers;
- (void)enableScrollsToTop;
- (void)disableScrollsToTop;
- (void) setupScrollView;
    
@end

@implementation ISColumnsController

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self) {
        [self view];
        [self loadTitleView];
        [self addObserver:self
               forKeyPath:@"viewControllers"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
    return self;
}

- (void)loadTitleView
{
    UIView *titleView = [[[UIView alloc] init] autorelease];
    titleView.frame = CGRectMake(0, 0, 150, 44);
    titleView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.pageControl = [[[UIPageControl alloc] init] autorelease];
    self.pageControl.numberOfPages = 200;
    self.pageControl.frame = CGRectMake(0, 27, 150, 14);
    self.pageControl.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin|
                                         UIViewAutoresizingFlexibleBottomMargin|
                                         UIViewAutoresizingFlexibleHeight);
    [self.pageControl addTarget:self
                         action:@selector(didTapPageControl)
               forControlEvents:UIControlEventValueChanged];
    
    [titleView addSubview:self.pageControl];
    
    self.titleLabel = [[[UILabel alloc] init] autorelease];
    self.titleLabel.frame = CGRectMake(0, 5, 150, 24);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.shadowColor = [UIColor darkGrayColor];
    self.titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin|
                                        UIViewAutoresizingFlexibleBottomMargin|
                                        UIViewAutoresizingFlexibleHeight);
    
    [titleView addSubview:self.titleLabel];
    
    self.navigationItem.titleView = titleView;
}

- (void)loadView
{
    [super loadView];
    [self setupScrollView];
}

- (void) setupScrollView {

    self.scrollView = [[[UIScrollView alloc] init] autorelease];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [self.view addSubview:self.scrollView];
    
    CALayer *topShadowLayer = [CALayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-10, -10, 10000, 13)];
    topShadowLayer.frame = CGRectMake(-320, 0, 10000, 20);
    topShadowLayer.masksToBounds = YES;
    topShadowLayer.shadowOffset = CGSizeMake(2.5, 2.5);
    topShadowLayer.shadowOpacity = 0.5;
    topShadowLayer.shadowPath = [path CGPath];
    [self.scrollView.layer addSublayer:topShadowLayer];

    CALayer *bottomShadowLayer = [CALayer layer];
    path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 10, 10000, 13)];
    bottomShadowLayer.frame = CGRectMake(-320, self.scrollView.frame.size.height-58, 10000, 20);
    bottomShadowLayer.masksToBounds = YES;
    bottomShadowLayer.shadowOffset = CGSizeMake(-2.5, -2.5);
    bottomShadowLayer.shadowOpacity = 0.5;
    bottomShadowLayer.shadowPath = [path CGPath];
    [self.scrollView.layer addSublayer:bottomShadowLayer];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadChildViewControllers];
    [self.pageControl addObserver:self
                       forKeyPath:@"currentPage"
                          options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                          context:nil];
    
}

- (void)viewDidUnload
{
    self.scrollView = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"viewControllers"];
    [self.pageControl removeObserver:self forKeyPath:@"currentPage"];
    
    [_viewControllers release];
    [_scrollView release];
    [_titleLabel release];
    [_pageControl release];
    
    [super dealloc];
}

#pragma mark - interface orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    for (UIViewController *viewController in self.viewControllers) {
        NSInteger index = [self.viewControllers indexOfObject:viewController];
        
        viewController.view.transform = CGAffineTransformIdentity;
        viewController.view.frame = CGRectMake(self.scrollView.frame.size.width * index,
                                               0,
                                               self.scrollView.frame.size.width,
                                               self.scrollView.frame.size.height);
    }
    
    // go to the right page
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.viewControllers count], 1);
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*self.pageControl.currentPage, 0) animated:NO];
}

#pragma mark - key value observation

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"viewControllers"]) {
        [self reloadChildViewControllers];
        [self disableScrollsToTop];
    }
    
    if (object == self.pageControl && [keyPath isEqualToString:@"currentPage"]) {
        NSLog(@"Woooff");
        NSInteger previousIndex = [[change objectForKey:@"old"] integerValue];
        NSInteger currentIndex  = [[change objectForKey:@"new"] integerValue];
        
        if (previousIndex != currentIndex) {
            [self didChangeCurrentPage:currentIndex previousPage:previousIndex];
        }
    }
}

#pragma mark - action

- (void)didTapPageControl
{
    CGFloat offset = self.scrollView.contentOffset.x;
    CGFloat width  = self.scrollView.frame.size.width;
    
    NSInteger currentPage = (offset+(width/2))/width;
    NSInteger nextPage    = self.pageControl.currentPage;
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*nextPage, 0) animated:YES];
    
    if (currentPage != nextPage) {
        [self didChangeCurrentPage:nextPage previousPage:currentPage];
    }
}

- (void)didChangeCurrentPage:(NSInteger)currentIndex previousPage:(NSInteger)previousIndex
{
    
    NSLog(@"meow");
    UIViewController <ISColumnsControllerChild> *previousViewController = [self.viewControllers objectAtIndex:previousIndex];
    if ([previousViewController respondsToSelector:@selector(didResignActive)]) {
        [previousViewController didResignActive];
    }
    
    if (currentIndex == (self.viewControllers.count - 1)) {
        ViewController *nextPage = [[ViewController alloc] init];
        nextPage.pageNumber = ((ViewController *)previousViewController).pageNumber + 1;
        [self.viewControllers addObject:nextPage];
    }
    UIViewController <ISColumnsControllerChild> *currentViewController = [self.viewControllers objectAtIndex:currentIndex];
    if ([currentViewController respondsToSelector:@selector(didBecomeActive)]) {
        [currentViewController didBecomeActive];
    }

    self.titleLabel.text = currentViewController.navigationItem.title;
}

- (void)reloadChildViewControllers
{
    //self.scrollView.contentSize = CGSizeZero;
    //[self setupScrollView];
    for (UIViewController *viewController in self.childViewControllers) {
        //[viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
        [viewController.view removeFromSuperview];
        viewController.view.transform = CGAffineTransformIdentity;
    }
    int index = 0;
    for (UIViewController *viewController in self.viewControllers) {
        viewController.view.frame = CGRectMake(self.scrollView.frame.size.width * index,
                                               0,
                                               self.scrollView.frame.size.width,
                                               self.scrollView.frame.size.height);
        
        [self addChildViewController:viewController];
        
        [self.scrollView addSubview:viewController.view];
        //[viewController didMoveToParentViewController:self];
        /*
        if (index == self.pageControl.currentPage) {
            self.titleLabel.text = viewController.navigationItem.title;
            if ([viewController respondsToSelector:@selector(didBecomeActive)]) {
                [(id)viewController didBecomeActive];
            }
        }
         */
        index++;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.viewControllers count], 1);
    
    
    /*
    for (UIViewController *viewController in self.childViewControllers) {
        CALayer *layer = viewController.view.layer;
        layer.shadowOpacity = .5f;
        layer.shadowOffset = CGSizeMake(10, 10);
        layer.shadowPath = [UIBezierPath bezierPathWithRect:viewController.view.frame].CGPath;
    }
     */
}

- (void)enableScrollsToTop
{
    // FIXME: this code affects all scroll view
    for (UIViewController *viewController in self.viewControllers) {
        for (UIView *subview in [viewController.view subviews]) {
            if ([subview respondsToSelector:@selector(scrollsToTop)]) {
                [(UIScrollView *)subview setScrollsToTop:YES];
            }
        }
    }
}

- (void)disableScrollsToTop
{
    for (UIViewController *viewController in self.viewControllers) {
        NSInteger index = [self.viewControllers indexOfObject:viewController];
        if (index != self.pageControl.currentPage) {
            for (UIView *subview in [viewController.view subviews]) {
                if ([subview respondsToSelector:@selector(scrollsToTop)]) {
                    [(UIScrollView *)subview setScrollsToTop:NO];
                }
            }
        }
    }
}

#pragma mark - scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self enableScrollsToTop];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat offset = self.scrollView.contentOffset.x;
    CGFloat width = self.scrollView.frame.size.width;
    int newCurrentPage = ((offset+(width/2))/width);
    if (newCurrentPage != self.pageControl.currentPage) {
        if (newCurrentPage == (self.viewControllers.count - 2)) {
            ViewController *nextPage = [[ViewController alloc] init];
            nextPage.pageNumber = ((ViewController *)[self.viewControllers objectAtIndex:(newCurrentPage + 1)]).pageNumber + 1;
            [self.viewControllers addObject:nextPage];
            [self reloadChildViewControllers];
        }
    }
    [self.pageControl setCurrentPage:((offset+(width/2))/width)];
    NSLog(@"current page %d", self.pageControl.currentPage);
    
    [self disableScrollsToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    NSArray *viewControllersToTransform;
    int currentPage = floor(offset / self.scrollView.frame.size.width);
    viewControllersToTransform = self.viewControllers;
    int start = (currentPage - 1 ) < 0 ? 0 : currentPage - 1;
    int end = currentPage + 2;
    for (int i = start; i < end; i++) {
        if (i >= self.viewControllers.count) return;
        ViewController *viewController = [self.viewControllers objectAtIndex:i];
        NSLog(@"thetext : %@, the height :%f, width: %f, x: %f, y: %f", viewController.text.text, viewController.view.frame.size.height, viewController.view.frame.size.width, viewController.view.frame.origin.x, viewController.view.frame.origin.y);
        CGFloat width = self.scrollView.frame.size.width;
        CGFloat y = i * width;
        CGFloat value = (offset-y)/width;
        NSLog(@"y: %f offset: %f, value: %f", y, offset, value);
        CGFloat scale = 1.f-fabs(value);
        NSLog(@"scale :%f", scale);
        NSLog(@" :%f", scale);
        if (scale > 1.f) scale = 1.f;
        if (scale < .8f) scale = .8f;
        
        viewController.view.transform = CGAffineTransformMakeScale(scale, scale);
        
        CALayer *layer = viewController.view.layer;
        layer.shadowPath = [UIBezierPath bezierPathWithRect:viewController.view.bounds].CGPath;
    }
}

@end
