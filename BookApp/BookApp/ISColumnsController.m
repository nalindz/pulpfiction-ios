#import "ISColumnsController.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "SlideViewCell.h"
#import "Block.h"
#import "Page.h"
#import "NSString+FitInLabel.h"
#import "API.h"
#import "Bookmark.h"
#import <dispatch/dispatch.h>


@interface ISColumnsController ()

- (void)enableScrollsToTop;
- (void)disableScrollsToTop;
- (void) setupScrollView;

- (NSInteger)numberOfPages;
- (SlideViewCell *) viewAtIndex: (NSInteger) index;
- (void)enqueueReusableView:(SlideViewCell *)view;
- (void) reloadData;

@property (nonatomic, assign, readwrite) CGFloat colWidth;
@property (nonatomic, assign, readwrite) NSInteger numCols;
@property (nonatomic, assign) UIInterfaceOrientation orientation;

@property (atomic, retain) NSMutableSet *reuseableViews;
@property (atomic, retain) NSMutableDictionary *visibleViews;
@property (atomic, retain) NSMutableArray *viewKeysToRemove;
@property (atomic, retain) NSMutableDictionary *indexToRectMap;


@property (atomic) int firstPageNumber;
@property (atomic) int lastPageNumber;
@property BOOL stopLoadingPages;


- (void)removeAndAddCellsIfNecessary;
    
@end

@implementation ISColumnsController

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self) {
        [self view];
        [self loadTitleView];
        /*
        [self addObserver:self
              forKeyPath:@"viewControllers"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        */
        
        //[self reloadData];
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


- (void) createNumberOfPages:(int) numberOfPages
          startingPageNumber: (NSNumber *) pageNumber
                   fromBlock:(NSNumber *) startBlockNumber
                       index:(NSInteger) startBlockIndex
                  pageBuffer: (NSString *) pageBuffer {
    
    
    NSLog(@"requesting page number: %@", pageNumber);
    int splitIndex = pageBuffer.length;
    int oldPageBufferLength;
    Block *currentBlock;
    while (splitIndex == pageBuffer.length) {
        currentBlock = [Block findFirstWithPredicate:[NSPredicate predicateWithFormat:@"block_number == %@ AND story_id == %@", startBlockNumber, self.story.id]];
        if (currentBlock == nil) {
            int endBlockNumber = [startBlockNumber integerValue] + 5;
            [RKObjectManager.sharedManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"stories/%@/blocks?first_block=%d&last_block=%d", self.story.id, [startBlockNumber integerValue], endBlockNumber] usingBlock:^(RKObjectLoader *loader) {
                loader.onDidLoadObjects = ^(NSArray *objects) {
                    
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                    [self createNumberOfPages: numberOfPages
                           startingPageNumber: pageNumber
                                    fromBlock:startBlockNumber
                                        index:startBlockIndex
                                   pageBuffer:pageBuffer];
                });
                };
            }];
            return;
        }
        
        oldPageBufferLength = pageBuffer.length;
        NSLog(@"old pageBuffer length: %d", pageBuffer.length);
        NSString *textToAdd = [currentBlock.text substringFromIndex:startBlockIndex];
        if ([pageBuffer hasSuffix:@"\n"] &&
            [[currentBlock.text substringFromIndex:startBlockIndex] hasPrefix:@" "]) {
            textToAdd = [[currentBlock.text substringFromIndex:startBlockIndex] substringFromIndex:1];
        }
            
        pageBuffer = [NSString stringWithFormat:@"%@%@",
                      pageBuffer,
                      textToAdd];
        
        NSLog(@"pageBuffer: '%@'", pageBuffer);
        NSLog(@"pageBuffer length: %d", pageBuffer.length);
        
        UIFont *pageFont = [self fontForSlideViewCell];
        
        
        splitIndex = [pageBuffer getSplitIndexWithSize:[self pageSize] andFont:pageFont];
        NSLog(@"The split index: %d", splitIndex);
        startBlockNumber = [NSNumber numberWithInt:([startBlockNumber intValue] + 1)];
        if ([currentBlock.last_block boolValue]) break;
        startBlockIndex = 0;
        if (splitIndex < 0) {
            splitIndex = oldPageBufferLength;
            break;
        }
    }
    
    int lastBlockIndex = splitIndex - oldPageBufferLength;
    
    Page *newPage = [Page object];
    newPage.page_number = pageNumber;
    newPage.story_id = self.story.id;
    newPage.text = [pageBuffer substringToIndex:splitIndex];
    newPage.first_block_number = startBlockNumber;
    newPage.first_block_index = [NSNumber numberWithInt:startBlockIndex];
    newPage.last_block_number = currentBlock.block_number;
    newPage.last_block_index = [NSNumber numberWithInt:lastBlockIndex];
    
    
    NSError *error;
    
    
    
    NSLog(@"last block index: %d", lastBlockIndex);
    
    if ([pageNumber intValue] > self.lastPageNumber) {
        self.lastPageNumber = [pageNumber intValue];
    }
    
    if ([pageNumber intValue] < self.firstPageNumber) {
        self.firstPageNumber = [pageNumber intValue];
    }
    
    numberOfPages--;
    
    [[newPage managedObjectContext] save:&error];
    if (numberOfPages > 0 && ![currentBlock.last_block boolValue]) {
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            [self createNumberOfPages:numberOfPages
                   startingPageNumber:[NSNumber numberWithInt:([pageNumber intValue] + 1)]
                            fromBlock:newPage.last_block_number
                                index:[newPage.last_block_index intValue]
                           pageBuffer:@""];
        });
         
    }
    //[self.scrollView  reloadData];
    NSLog(@"firstPageNumber: %d, lastPageNumbeR: %d", self.firstPageNumber ,self.lastPageNumber);
}


- (int)pageMargin {
    return 60;
}

- (CGSize) pageSize {
    return CGSizeMake(self.scrollView.frame.size.width - ([self pageMargin] * 2), self.scrollView.frame.size.height - ([self pageMargin] * 2));
}

- (void) objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
}



- (void) setupScrollView {

    self.scrollView = [[[SlideScrollView alloc] initWithFrame:CGRectZero] autorelease];
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
    self.scrollView.dataSource = self;
    
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
    [self.scrollView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstPageNumber = 0;
    self.lastPageNumber = 0;
    
 [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(receiveTestNotification)
        name:@"changesMerged"
        object:nil];
}
- (void)receiveTestNotification {
    NSLog(@"updated meow here");
    [self.scrollView reloadData];
}



- (void) setStartingPageNumber: (NSNumber *) startingPageNumber {
    self.firstPageNumber = [startingPageNumber intValue];
    self.lastPageNumber = [startingPageNumber intValue];
    _startingPageNumber = startingPageNumber;
}

- (void) viewWillAppear:(BOOL)animated {
    if (self.startingPageNumber == nil) {
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                    [self createNumberOfPages:2
               startingPageNumber:@(0)
                        fromBlock:@(0)
                            index:0
                       pageBuffer:@""];
                });
        [self startOnPageNumber: 0];
    } else {
        
    Page *page = [Page findFirstWithPredicate:[NSPredicate predicateWithFormat:@"page_number == %@ AND story_id == %@", self.startingPageNumber, self.story.id]];
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                    [self createNumberOfPages:2
               startingPageNumber:@([page.page_number intValue] + 1)
                        fromBlock:page.last_block_number
                            index:[page.last_block_index intValue]
                       pageBuffer:@""];
                });
        
        [self startOnPageNumber: [page.page_number intValue]];
    }
}


- (void)startOnPageNumber: (int) pageNumber {
    self.scrollView.contentOffset = CGPointMake(pageNumber * self.scrollView.width, 0);
    [self.scrollView reloadData];
}

- (void)viewDidUnload
{
    self.scrollView = nil;
    
    [super viewDidUnload];
}


- (void)didChangeCurrentPage:(NSInteger)currentIndex previousPage:(NSInteger)previousIndex
{
   /*
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
    */
}

- (NSInteger)numberOfPages {
    return self.lastPageNumber + 1;
}

- (SlideViewCell *) viewAtIndex: (NSInteger) index {
    NSLog(@"Loading page: %d", index);
    SlideViewCell *cell = [[SlideViewCell alloc] initWithFrame:self.view.frame];
    cell.backgroundColor = [UIColor whiteColor];
    
    Page *page = [Page findFirstWithPredicate:[NSPredicate predicateWithFormat:@"page_number == %d AND story_id == %@", index, self.story.id]];
    
    
    Page *unfaultedPage = [page unfault];
    
//NSLog(@"The page: %@", page);
    NSLog(@"The unfaulted page: %@", unfaultedPage);
    cell.delegate = self;
    [cell renderWithPage:unfaultedPage];
    return cell;
}

- (void)backClicked {
    Bookmark *bookmark = [Bookmark findFirstWithPredicate:[NSPredicate predicateWithFormat:@"story_id == %@ AND auto_bookmark == %@", self.story.id, @(YES)]];
    if (bookmark == nil) {
        bookmark = [Bookmark object];
    }
    
    bookmark.page = [self currentPage];
    bookmark.story_id = self.story.id;
    bookmark.auto_bookmark = @(YES);
    [[bookmark managedObjectContext] save:nil];
    [self.scrollView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (Page *) currentPage {
    Page *page = [Page findFirstWithPredicate:[NSPredicate predicateWithFormat:@"page_number == %d AND story_id == %@", self.pageControl.currentPage, self.story.id]];
    return page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat offset = self.scrollView.contentOffset.x;
    CGFloat width = self.scrollView.frame.size.width;
    int newCurrentPage = ((offset+(width/2))/width);
    if (newCurrentPage != self.pageControl.currentPage) {
        if (newCurrentPage == (self.lastPageNumber) && self.stopLoadingPages == NO) {
            Page *page = [Page findFirstWithPredicate:[NSPredicate predicateWithFormat:@"page_number == %d AND story_id == %@", self.pageControl.currentPage + 1, self.story.id]];
            
            
            Page *unfaultedPage = [page unfault];
            NSLog(@"delecerate The unfaulted page: %@", unfaultedPage);
            
            Block *lastBlock = [Block findFirstWithPredicate:[NSPredicate predicateWithFormat:@"block_number == %@ AND story_id == %@", unfaultedPage.last_block_number , self.story.id]];
            
            if (![lastBlock.last_block boolValue]) {
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                [self createNumberOfPages:2 startingPageNumber:[NSNumber numberWithInt:(self.lastPageNumber + 1)] fromBlock:unfaultedPage.last_block_number index:[unfaultedPage.last_block_index intValue] pageBuffer:@""];
                });
            } else {
                self.stopLoadingPages = YES;
            }
        }
    }
    [self.pageControl setCurrentPage:((offset+(width/2))/width)];
    NSLog(@"current page %d", self.pageControl.currentPage);
    
}

- (UIFont *) fontForSlideViewCell {
    return [UIFont fontWithName:@"Meta Serif OT" size:30];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offset = scrollView.contentOffset.x;
    int currentPage = floor(offset / self.scrollView.frame.size.width);
    
    for (UIView *viewController in self.scrollView.subviews) {
        //SlideViewCell *viewController = [self.scrollView.subviews objectAtIndex:i];
        //NSLog(@"thetext : %@, the height :%f, width: %f, x: %f, y: %f", viewController.text.text, viewController.view.frame.size.height, viewController.view.frame.size.width, viewController.view.frame.origin.x, viewController.view.frame.origin.y);
        CGFloat width = self.scrollView.frame.size.width;
        int i = viewController.frame.origin.x / width;
        CGFloat y = i * width;
        CGFloat value = (offset-y)/width;
        CGFloat scale = 1.f-fabs(value);
        if (scale > 1.f) scale = 1.f;
        if (scale < .8f) scale = .8f;
        
        viewController.transform = CGAffineTransformMakeScale(scale, scale);
        
        CALayer *layer = viewController.layer;
        layer.shadowPath = [UIBezierPath bezierPathWithRect:viewController.bounds].CGPath;
    }
}

@end
