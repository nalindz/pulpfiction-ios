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
#include <math.h>
#include "PageCell.h"


#define pagesToBuffer 10000

#define FONT_MAX_SIZE 50.0
#define FONT_MIN_SIZE 10.0


@interface ISColumnsController ()

- (void) setupScrollView;

- (NSInteger)numberOfPages;
- (void) reloadData;

@property (atomic, strong) dispatch_queue_t backgroundQueue;
@property (atomic, strong) dispatch_queue_t fontQueue;

@property (atomic) int firstPageNumber;
@property (atomic) int lastPageNumber;

@property (atomic) int pagesOutstanding;

@property BOOL stopLoadingPages;

@property  BOOL loadingPages;
@property (atomic) BOOL lastPageSeen;


@property  BOOL LP;
@property  (atomic) BOOL stopAddingJobs;


@property (nonatomic, strong) UIFont *pageFont;

// bleh globals - should be in a closure
@property (nonatomic, strong) NSNumber *viewingBlockNumber;
@property (nonatomic, strong) NSNumber *viewingBlockIndex;


- (void)removeAndAddCellsIfNecessary;
    
@end

@implementation ISColumnsController


#pragma mark - life cycle

- (UIFont *)pageFont {
    if (_pageFont == nil) {
        //default font
       _pageFont = [UIFont fontWithName:@"Meta Serif OT" size:30];
    }
    return _pageFont;
}


- (id)init
{
    self = [super init];
    if (self) {
        [self view];
        [self loadTitleView];
        self.backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
    return self;
}


- (void)loadTitleView
{
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, 150, 44);
    titleView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = 200;
    self.pageControl.frame = CGRectMake(0, 27, 150, 14);
    self.pageControl.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin|
                                         UIViewAutoresizingFlexibleBottomMargin|
                                         UIViewAutoresizingFlexibleHeight);
    [self.pageControl addTarget:self
                         action:@selector(didTapPageControl)
               forControlEvents:UIControlEventValueChanged];
    
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
    int oldPageBufferLength = 0;
    Block *currentBlock;
    int currentBlockNumber = [startBlockNumber intValue];
    int currentBlockIndex = startBlockIndex;
    
    
    while (splitIndex == pageBuffer.length) {
        currentBlock = [Block findFirstWithPredicate:[NSPredicate predicateWithFormat:@"block_number == %@ AND story_id == %@", @(currentBlockNumber), self.story.id]];
        if (currentBlock == nil) {
            int endBlockNumber = currentBlockNumber + 10;
            [RKObjectManager.sharedManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"stories/%@/blocks?first_block=%d&last_block=%d", self.story.id, currentBlockNumber, endBlockNumber] usingBlock:^(RKObjectLoader *loader) {
                loader.onDidLoadObjects = ^(NSArray *objects) {
                    
                    if (self.stopAddingJobs) return;
                    dispatch_async( self.backgroundQueue,  ^(void) {
                    [self createNumberOfPages: numberOfPages
                           startingPageNumber: @([pageNumber intValue])
                                    fromBlock:@(currentBlockNumber)
                                        index:currentBlockIndex
                                   pageBuffer:[NSString stringWithFormat:@"%@", pageBuffer]];
                });
                };
            }];
            return;
        }
        
        oldPageBufferLength = pageBuffer.length;
        NSLog(@"old pageBuffer length: %d", pageBuffer.length);
        NSString *textToAdd = [currentBlock.text substringFromIndex:currentBlockIndex];
        
        
        /*
        if ([pageBuffer hasSuffix:@"\n"] &&
            [[currentBlock.text substringFromIndex:currentBlockIndex] hasPrefix:@" "]) {
            textToAdd = [[currentBlock.text substringFromIndex:currentBlockIndex] substringFromIndex:1];
        }
         */
        
        
        pageBuffer = [NSString stringWithFormat:@"%@%@",
                      pageBuffer,
                      textToAdd];
        
        
        CGSize size = [self pageSize];
        splitIndex = [pageBuffer getSplitIndexWithSize:size andFont:self.pageFont];
        currentBlockNumber++;
        if ([currentBlock.last_block boolValue]) break;
        currentBlockIndex = 0;
        if (splitIndex < 0) {
            splitIndex = oldPageBufferLength;
            break;
        }
    }
    
   int lastBlockIndex = splitIndex - oldPageBufferLength + currentBlockIndex;
    
    
    Page *newPage = [Page pageWithNumber:pageNumber storyId:self.story.id];
    if (newPage == nil) newPage = [Page object];
    newPage.page_number = pageNumber;
    newPage.story_id = self.story.id;
    newPage.text = [pageBuffer substringToIndex:splitIndex];
    newPage.first_block_number = startBlockNumber;
    newPage.first_block_index = [NSNumber numberWithInt:startBlockIndex];
    newPage.last_block_number = currentBlock.block_number;
    newPage.last_block_index = [NSNumber numberWithInt:lastBlockIndex];
    
    
    NSError *error;
    
    if ([pageNumber intValue] > self.lastPageNumber) {
        self.lastPageNumber = [pageNumber intValue];
    }
    
    if ([pageNumber intValue] < self.firstPageNumber) {
        self.firstPageNumber = [pageNumber intValue];
    }
    
    if ([newPage isLastPage]) {
        //[self.scrollView reloadData];
        numberOfPages = 0;
        self.pagesOutstanding = 0;
        [self scrollToCorrectPage];
        self.lastPageSeen = YES;
        self.loadingPages = NO;
        self.LP = NO;
    } else {
        numberOfPages--;
        self.pagesOutstanding--;
        if (self.pagesOutstanding == 0) {
            self.loadingPages = NO;
        }
    }
    
    [[newPage managedObjectContext] save:&error];
    
    if (numberOfPages > 0) {
        if (self.stopAddingJobs) return;
        dispatch_async(self.backgroundQueue, ^(void) {
            [self createNumberOfPages:numberOfPages
                   startingPageNumber:[NSNumber numberWithInt:([pageNumber intValue] + 1)]
                            fromBlock:@([newPage.last_block_number intValue])
                                index:[newPage.last_block_index intValue]
                           pageBuffer:@""];
        });
         
    }
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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.scrollView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.dataSource = self;
    [self.scrollView registerClass:[SlideViewCell class] forCellWithReuseIdentifier:@"slideViewCell"];
    
    [self.view addSubview:self.scrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstPageNumber = 0;
    self.lastPageNumber = -1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveManagedObjectUpdate:)
                                                 name:@"changesMerged"
                                               object:nil];
}

- (void)receiveManagedObjectUpdate: (NSNotification *) notification {
    NSLog(@"updated meow here: %@", notification);
    NSArray *insertedData = [notification.userInfo objectForKey:@"inserted"];
    NSArray *updatedData = [notification.userInfo objectForKey:@"updated"];
    NSMutableArray *insertedAndUpdatedData = [[NSMutableArray alloc] init];
    
    
    if (insertedData != nil && insertedData.count > 0) {
        [insertedAndUpdatedData addObjectsFromArray:insertedData];
    }
    if (updatedData != nil && updatedData.count > 0) {
        [insertedAndUpdatedData addObjectsFromArray:updatedData];
    }
    
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsToReload = [[NSMutableArray alloc] init];
    for (NSManagedObject *object in insertedAndUpdatedData) {
        if ([object class] == [Page class]) {
            Page *page = (Page *)object;
            //if ([page.page_number intValue] < self.lastPageNumber) {
            if (1) {
                [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:[page.page_number intValue] inSection:0]];
            } else {
                [indexPathsToReload addObject:[NSIndexPath indexPathForRow:[page.page_number intValue] inSection:0]];
            }
        }
        
    }
    
    if (indexPathsToInsert.count > 0) {
        NSLog(@"inserting: %d", indexPathsToInsert.count);
        for (NSIndexPath *path in indexPathsToInsert) {
            NSLog(@"the index path: %@", path);
        }
        [self.scrollView insertItemsAtIndexPaths:indexPathsToInsert];
    }

    
    
    /*
    if (indexPathsToInsert.count > 0) {
        [self.scrollView insertItemsAtIndexPaths:indexPathsToInsert];
    }
    
    NSMutableArray *indexPathsToReload = [[NSMutableArray alloc] init];
    for (NSManagedObject *object in updatedData) {
        if ([object class] == [Page class]) {
            Page *page = (Page *)object;
            
            [indexPathsToReload addObject:[NSIndexPath indexPathForRow:[page.page_number intValue] inSection:0]];
        }
    }
    
    if (indexPathsToReload.count > 0) {
        [self.scrollView reloadItemsAtIndexPaths:indexPathsToInsert];
        //[self.scrollView reloadData];
    }
    
    
    if (insertedData.count > 0) {
        //[self.scrollView reloadData];
    }
     */
}


- (void) setStartingPageNumber: (NSNumber *) startingPageNumber {
    self.firstPageNumber = [startingPageNumber intValue];
    self.lastPageNumber = [startingPageNumber intValue];
    _startingPageNumber = startingPageNumber;
    self.pageControl.currentPage = [startingPageNumber intValue];
}

- (void) viewWillAppear:(BOOL)animated {
    self.pagesOutstanding = pagesToBuffer;
    [self buildAllPages];
    if (self.startingPageNumber == nil) {
        //[self scrollToPageNumber:0];
    } else {
        //[self scrollToPageNumber:[self.startingPageNumber intValue]];
    }
}


- (void)scrollToPageNumber: (int) pageNumber {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(pageNumber) inSection:0];
    [self.scrollView scrollToItemAtIndexPath:indexPath atScrollPosition: UICollectionViewScrollPositionLeft animated:YES];
    //[self.scrollView reloadItemsAtIndexPaths:@[indexPath]];
}

- (BOOL) isBlockNumber:(int) blockNumber andIndex: (int) index inPage: (Page *) page {
    if ([page.first_block_number intValue] <= [self.viewingBlockNumber intValue]
        && [page.last_block_number intValue] >= [self.viewingBlockNumber intValue]) {
        if ([page.first_block_number intValue] == blockNumber) {
            if ([page.first_block_index intValue] <= index) return true;
        } else if ([page.last_block_number intValue] == blockNumber) {
            if ([page.last_block_index intValue] >= index) {
                return true;
            }
        } else {
            return true;
        }
    }
    return false;
}

-(void) scrollToCorrectPage {
    if (self.viewingBlockNumber == nil) {
        return;
    }
    int pageToScrollTo = 0;
    Page *page;
    while (pageToScrollTo <= self.lastPageNumber) {
        page = [Page pageWithNumber:@(pageToScrollTo) storyId:self.story.id];
        if ([self isBlockNumber:[self.viewingBlockNumber intValue] andIndex:[self.viewingBlockIndex intValue] inPage:page]) break;
        pageToScrollTo++;
    }
    
    [self scrollToPageNumber:pageToScrollTo];
}

- (void) buildAllPages {
    self.loadingPages = YES;
    self.LP = YES;
    self.lastPageNumber = -1;
    if (self.stopAddingJobs) return;
    dispatch_async(self.backgroundQueue, ^(void) {
        [self createNumberOfPages:pagesToBuffer
               startingPageNumber:@(0)
                        fromBlock:@(0)
                            index:0
                       pageBuffer:@""];
    });
}

- (NSInteger)numberOfPages {
    return self.lastPageNumber + 1;
}

- (void)fontIncrease {
    CGFloat fontSize = self.pageFont.pointSize;
    fontSize += 5.0;
    if (fontSize >= FONT_MAX_SIZE) {
        return;
    }
    //self.stopAddingJobs = YES;
    dispatch_async(self.backgroundQueue, ^{[self moreFontIncrease];});
}

- (void) moreFontIncrease {
    //self.stopAddingJobs = NO;
    self.lastPageNumber = -1;
    [self.scrollView reloadData];
    
   // self.lastPageNumber = -1;
    
    CGFloat fontSize = self.pageFont.pointSize;
    fontSize += 5.0;
    if (fontSize >= FONT_MAX_SIZE) {
        return;
    }
    self.pageFont = [UIFont fontWithName:@"Meta Serif OT" size:fontSize];
    [self buildAllPages];
}

- (void)fontDecrease {
    
    //dispatch_release(self.backgroundQueue);
    //self.backgroundQueue = dispatch_queue_create("backgroundQueue2", NULL);
    //if (self.loadingPages) return;
    CGFloat fontSize = self.pageFont.pointSize;
    fontSize -= 5.0;
    if (fontSize <= FONT_MIN_SIZE) {
        return;
    }
    self.pageFont = [UIFont fontWithName:@"Meta Serif OT" size:fontSize];
    [self buildAllPages];
}


- (void)backClicked {
    /*
    Bookmark *bookmark = [Bookmark findFirstWithPredicate:[NSPredicate predicateWithFormat:@"story_id == %@ AND auto_bookmark == %@", self.story.id, @(YES)]];
    if (bookmark == nil) {
        bookmark = [Bookmark object];
    }
    
    bookmark.page = [self currentPage];
    bookmark.story_id = self.story.id;
    bookmark.auto_bookmark = @(YES);
    [[bookmark managedObjectContext] save:nil];
   */
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewPop {
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
        if (newCurrentPage > (self.lastPageNumber - pagesToBuffer + 1)) {
            //[self getMorePages];
        } else {
            //self.stopLoadingPages = YES;
        }
    }
    [self.pageControl setCurrentPage:((offset+(width/2))/width)];
    NSLog(@"current page %d", self.pageControl.currentPage);
}

- (void) getMorePages {
    if (self.pagesOutstanding > 0) return;
    if (self.loadingPages) return;
    self.loadingPages = YES;
    NSLog(@"The last page: %d", self.lastPageNumber);
    
    Page *page = [Page findFirstWithPredicate:[NSPredicate predicateWithFormat:@"page_number == %d AND story_id == %@", self.lastPageNumber, self.story.id]];
    
    if (![page isLastPage]) {
        self.pagesOutstanding = pagesToBuffer;
        if (self.stopAddingJobs) return;
        dispatch_async(self.backgroundQueue, ^(void) {
            [self createNumberOfPages:pagesToBuffer startingPageNumber:[NSNumber numberWithInt:(self.lastPageNumber + 1)] fromBlock:@([page.last_block_number intValue]) index:[page.last_block_index intValue] pageBuffer:@""];
        });
    }
}

- (UIFont *) fontForSlideViewCell {
    return self.pageFont;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offset = scrollView.contentOffset.x;
    
    for (UIView *viewController in self.scrollView.subviews) {
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

#pragma mark collectionView delegate methods


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfPages];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView { 
    return 1;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SlideViewCell *cell = [self.scrollView dequeueReusableCellWithReuseIdentifier:@"slideViewCell" forIndexPath:indexPath];
    
    [cell renderWithPageNumber:@(indexPath.row) storyId:self.story.id font:self.pageFont margin:[self pageMargin]];
    cell.delegate = self;
    //cell.tag = [self cellTagForIndexPath: indexPath];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.scrollView.width , self.scrollView.height);
}




@end
