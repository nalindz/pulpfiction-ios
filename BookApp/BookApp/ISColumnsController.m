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

@property (atomic) int firstPageNumber;
@property (atomic) int lastPageNumber;


@property (atomic, strong) UIView *loadingShot;
@property  (atomic) BOOL stopAddingJobs;

@property (nonatomic, strong) UIFont *pageFont;

// bleh globals - should be in a closure
@property (nonatomic, strong) NSNumber *viewingBlockNumber;
@property (nonatomic, strong) NSNumber *viewingBlockIndex;

@property (atomic) BOOL fontClickDisabled;

- (void)removeAndAddCellsIfNecessary;
    
@end

@implementation ISColumnsController


#pragma mark - life cycle

- (UIFont *)pageFont {
    if (_pageFont == nil) {
        //default font
       _pageFont = [UIFont fontWithName:@"Meta Serif OT" size:20];
    }
    return _pageFont;
}


- (id)init
{
    self = [super init];
    if (self) {
        [self view];
        [self loadTitleView];
        self.backgroundQueue = dispatch_queue_create("background.queue", nil);
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
}


- (void) createNumberOfPages:(int) numberOfPages
          startingPageNumber: (NSNumber *) pageNumber
                   fromBlock:(NSNumber *) startBlockNumber
                       index:(NSInteger) startBlockIndex
                  pageBuffer: (NSString *) pageBuffer {
    
    NSLog(@"requesting page number: %@", pageNumber);
    Block *currentBlock;
    int currentBlockNumber = [startBlockNumber intValue];
    int currentBlockIndex = startBlockIndex;
    int currentPageNumber = [pageNumber intValue];
    NSString *myPageBuffer = [pageBuffer copy];
    
    while (numberOfPages > 0) {
        int splitIndex = myPageBuffer.length;
        int oldmyPageBufferLength = 0;
        if (self.stopAddingJobs) return;
        while (splitIndex == myPageBuffer.length) {
            currentBlock = [Block findFirstWithPredicate:[NSPredicate predicateWithFormat:@"block_number == %@ AND story_id == %@", @(currentBlockNumber), self.story.id]];
            if (currentBlock == nil) {
                int endBlockNumber = currentBlockNumber + 10;
                [RKObjectManager.sharedManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"stories/%@/blocks?first_block=%d&last_block=%d", self.story.id, currentBlockNumber, endBlockNumber] usingBlock:^(RKObjectLoader *loader) {
                    loader.onDidLoadObjects = ^(NSArray *objects) {
                        
                        if (self.stopAddingJobs) return;
                        dispatch_async( self.backgroundQueue,  ^(void) {
                            [self createNumberOfPages: numberOfPages
                                   startingPageNumber:@(currentPageNumber)
                                            fromBlock:@(currentBlockNumber)
                                                index:currentBlockIndex
                                           pageBuffer:[NSString stringWithFormat:@"%@", myPageBuffer]];
                        });
                    };
                }];
                return;
            }
            
            oldmyPageBufferLength = myPageBuffer.length;
            NSLog(@"old myPageBuffer length: %d", myPageBuffer.length);
            NSString *textToAdd = [currentBlock.text substringFromIndex:currentBlockIndex];
            
            
            /*
             if ([myPageBuffer hasSuffix:@"\n"] &&
             [[currentBlock.text substringFromIndex:currentBlockIndex] hasPrefix:@" "]) {
             textToAdd = [[currentBlock.text substringFromIndex:currentBlockIndex] substringFromIndex:1];
             }
             */
            
            
            myPageBuffer = [NSString stringWithFormat:@"%@%@",
                          myPageBuffer,
                          textToAdd];
            
            
            CGSize size = [self pageSize];
            splitIndex = [myPageBuffer getSplitIndexWithSize:size andFont:self.pageFont];
            currentBlockNumber++;
            if ([currentBlock.last_block boolValue]) break;
            currentBlockIndex = 0;
            if (splitIndex < 0) {
                splitIndex = oldmyPageBufferLength;
                break;
            }
        }
        
        int lastBlockIndex = splitIndex - oldmyPageBufferLength + currentBlockIndex;
        
        
        Page *newPage = [Page pageWithNumber:@(currentPageNumber) storyId:self.story.id];
        if (newPage == nil) newPage = [Page object];
        newPage.page_number = @(currentPageNumber);
        newPage.story_id = self.story.id;
        newPage.text = [myPageBuffer substringToIndex:splitIndex];
        newPage.first_block_number = startBlockNumber;
        newPage.first_block_index = [NSNumber numberWithInt:startBlockIndex];
        newPage.last_block_number = currentBlock.block_number;
        newPage.last_block_index = [NSNumber numberWithInt:lastBlockIndex];
        newPage.font_size = @(self.pageFont.pointSize);
        
        
        NSError *error;
        if (![[newPage managedObjectContext] save:&error]) {
            NSLog(@"Save failed: %@", error);
        }
        
        if ([newPage isLastPage]) {
            numberOfPages = 0;
            [self scrollToCorrectPage];
        } else {
            numberOfPages--;
        }
        
        
        currentPageNumber++;
        currentBlockIndex = [newPage.last_block_index intValue];
        currentBlockNumber = [newPage.last_block_number intValue];
        startBlockIndex = currentBlockIndex;
        startBlockNumber = @(currentBlockNumber);
        myPageBuffer = @"";
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

    self.scrollView = [[PageView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    
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
    [self setupScrollView];
    self.firstPageNumber = 0;
    self.lastPageNumber = -1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveManagedObjectUpdate:)
                                                 name:@"changesMerged"
                                               object:nil];
}

- (void)receiveManagedObjectUpdate: (NSNotification *) notification {
    if (self.stopAddingJobs) return;
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
    for (NSManagedObject *object in insertedAndUpdatedData) {
        if ([object class] == [Page class]) {
            Page *page = (Page *)object;
            if ([page.font_size floatValue] == self.pageFont.pointSize && [page.page_number intValue] - self.lastPageNumber == 1) {
                NSLog(@"The number of views: %d", [self.scrollView numberOfItemsInSection:0]);
                [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:[page.page_number intValue] inSection:0]];
                self.lastPageNumber = [page.page_number intValue];
                
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
    if (self.lastPageNumber > [self.startingPageNumber intValue] + 1 && self.startingPageNumber != nil) {
        [self scrollToCorrectPage];
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
    if ([self.startingPageNumber intValue] == 0) {
        self.startingPageNumber = nil;
    }
    [self buildAllPages];
    [self showLoadingPage];
}

- (void) showLoadingPage {
    if (self.startingPageNumber != nil) {
        self.loadingShot = [[UIView alloc] initWithFrame:self.view.bounds];
        self.loadingShot.backgroundColor = [UIColor blackColor];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,100,100)];
        spinner.center = self.view.center;
        [self.loadingShot addSubview:spinner];
        [spinner startAnimating];
        [self.view addSubview:self.loadingShot];
    }
}


- (void)scrollToPageNumber: (int) pageNumber {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(pageNumber) inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{[self.scrollView scrollToItemAtIndexPath:indexPath atScrollPosition: UICollectionViewScrollPositionLeft animated:NO];});
    //[self.scrollView reloadItemsAtIndexPaths:@[indexPath]];
}

- (BOOL) isBlockNumber:(int) blockNumber andIndex: (int) index inPage: (Page *) page {
    if ([page.first_block_number intValue] <= blockNumber
    && [page.last_block_number intValue] >= blockNumber) {
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
    int pageToScrollTo = 0;
    if (self.startingPageNumber != nil) {
        pageToScrollTo = [self.startingPageNumber intValue];
        self.startingPageNumber = nil;
    }
    else if (self.viewingBlockNumber == nil) {
        return;
    } else {
        Page *page;
        while (pageToScrollTo <= self.lastPageNumber) {
            page = [Page pageWithNumber:@(pageToScrollTo) storyId:self.story.id];
            if ([self isBlockNumber:[self.viewingBlockNumber intValue] andIndex:[self.viewingBlockIndex intValue] inPage:page]) break;
            pageToScrollTo++;
        }
    }
    
   [self scrollToPageNumber:pageToScrollTo];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"the loading shot: %d", self.loadingShot.hidden);
        self.loadingShot.hidden = YES;
        [self.view bringSubviewToFront:self.scrollView];
        NSLog(@"the loading shot: %d", self.loadingShot.hidden);
    });
    //self.loadingShot.hidden = YES;
    //[self.scrollView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.pageControl.currentPage inSection:0]]];
}

- (void) buildAllPages {
    self.lastPageNumber = -1;
    if (self.stopAddingJobs) return;
    
    [self showLoadingPage];
    dispatch_async(self.backgroundQueue, ^(void) {
        [self createNumberOfPages:pagesToBuffer
               startingPageNumber:@(0)
                        fromBlock:@(0)
                            index:0
                       pageBuffer:@""];
    });
}


- (void)fontIncrease {
    CGFloat fontSize = self.pageFont.pointSize;
    fontSize += 5.0;
    if (fontSize >= FONT_MAX_SIZE) return;
    self.pageFont = [UIFont fontWithName:@"Meta Serif OT" size:fontSize];
    [self fontChangeWithSize:fontSize];
}

- (void)fontDecrease {
    CGFloat fontSize = self.pageFont.pointSize;
    fontSize -= 5.0;
    if (fontSize <= FONT_MIN_SIZE) return;
    [self fontChangeWithSize:fontSize];
}

- (void) fontChangeWithSize: (CGFloat) fontSize {
    self.stopAddingJobs = YES;
    self.pageFont = [UIFont fontWithName:@"Meta Serif OT" size:fontSize];
    
    // save current page info
    
    Page *currentPage = [self currentPage];
    self.viewingBlockIndex = [currentPage.first_block_index copy];
    self.viewingBlockNumber = [currentPage.first_block_number copy];
    
   
    
    //UICollectionViewCell *cell = [self.scrollView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UIGraphicsBeginImageContextWithOptions(self.scrollView.frame.size,NO, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.loadingShot = [[UIImageView alloc] initWithImage:capturedImage];
    self.loadingShot.userInteractionEnabled = NO;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.loadingShot.center;
    [self.loadingShot addSubview:spinner];
    [spinner startAnimating];
   
    [self.view addSubview:self.loadingShot];
    
    
    dispatch_async(self.backgroundQueue, ^{[self finishFontChange];});
    
}

- (void) finishFontChange {
    self.lastPageNumber = -1;
    [self.scrollView reloadData];
    
    NSLog(@"The number of views: %d", [self.scrollView.dataSource collectionView:self.scrollView numberOfItemsInSection:0]);
    self.stopAddingJobs = NO;
    self.fontClickDisabled = NO;
    [self buildAllPages];
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

/*
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
 */

- (UIFont *) fontForSlideViewCell {
    return self.pageFont;
}

#pragma mark collectionView delegate methods


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.lastPageNumber + 1);
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
