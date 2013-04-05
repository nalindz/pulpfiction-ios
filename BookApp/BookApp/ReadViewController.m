#import "ReadViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PageCell.h"
#import "Block.h"
#import "Page+RestKit.h"
#import "NSString+FitInLabel.h"
#import "API.h"
#import "Bookmark.h"
#import <dispatch/dispatch.h>
#include <math.h>
#include "PageCell.h"
#import "StoryView.h"

#define pagesToBuffer 10000

#define FONT_MAX_SIZE 50.0
#define FONT_MIN_SIZE 10.0

@interface ReadViewController ()
@property (atomic, strong) dispatch_queue_t backgroundQueue;
@property (atomic) int firstPageNumber;
@property (atomic) int lastPageNumber;
@property (atomic) int totalPages;
@property (atomic) int currentPageNumber;

@property (atomic, strong) UIView *loadingShot;
@property  (atomic) BOOL stopAddingJobs;

@property (nonatomic, strong) UIFont *pageFont;
@property  BOOL showControls;

// bleh globals - should be in a closure
@property (nonatomic, strong) NSNumber *viewingBlockNumber;
@property (nonatomic, strong) NSNumber *viewingBlockIndex;
@property (atomic) BOOL fontClickDisabled;
@end

@implementation ReadViewController

#pragma mark - life cycle

- (UIFont *)pageFont {
    if (_pageFont == nil) {
        //default font
       _pageFont = [UIFont fontWithName:@"Meta Serif OT" size:20];
    }
    return _pageFont;
}

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundQueue = dispatch_queue_create("background.queue", nil);
    }
    return self;
}

- (void) createNumberOfPages:(int) numberOfPages
          startingPageNumber: (NSNumber *) pageNumber
                   fromBlock:(NSNumber *) startBlockNumber
                       index:(NSInteger) startBlockIndex
                  pageBuffer: (NSString *) pageBuffer {
    
    self.totalPages = 0;
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
                
                [RKObjectManager.sharedManager getObjectsAtPath:@"/blocks"
                                                     parameters:@{@"story_id": self.story.id,
                                                                  @"first_block": @(currentBlockNumber),
                                                                  @"last_block": @(endBlockNumber)}
                                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                            if (self.stopAddingJobs) return;
                                                            dispatch_async( self.backgroundQueue,  ^(void) {
                                                                [self createNumberOfPages: numberOfPages
                                                                       startingPageNumber:@(currentPageNumber)
                                                                                fromBlock:@(currentBlockNumber)
                                                                                    index:currentBlockIndex
                                                                               pageBuffer:[NSString stringWithFormat:@"%@", myPageBuffer]];
                                                            });
                                                        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                            NSLog(@"Error fetching blocks: %@", error);
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
        if (newPage == nil) newPage = [Page createEntity];
        newPage.page_number = @(currentPageNumber);
        newPage.story_id = self.story.id;
        newPage.text = [myPageBuffer substringToIndex:splitIndex];
        newPage.first_block_number = startBlockNumber;
        newPage.first_block_index = [NSNumber numberWithInt:startBlockIndex];
        newPage.last_block_number = currentBlock.block_number;
        newPage.last_block_index = [NSNumber numberWithInt:lastBlockIndex];
        newPage.font_size = @(self.pageFont.pointSize);
        self.totalPages++;
        
        
        /*
        NSError *error;
        if (![[newPage managedObjectContext] save:&error]) {
            NSLog(@"Save failed: %@", error);
        }
         */
        
        [[newPage managedObjectContext] saveToPersistentStoreAndWait];
        
        self.lastPageNumber = [newPage.page_number intValue];
        [self.scrollView reloadData];
        
        if ([newPage isLastPage]) {
            numberOfPages = 0;
            [self.scrollView reloadData];
            NSLog(@"The last page number :%d", self.lastPageNumber);
            [self scrollToCorrectPage];
            
            if (self.startingPageNumber == 0) {
                [self reloadFirstCell];
            }
            //[self reloadFirstCell];
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
    return 80;
}

- (Story *)story {
    return [Story findFirstByAttribute:@"id" withValue:self.storyId];
}

- (CGSize) pageSize {
    return CGSizeMake(self.scrollView.frame.size.width - ([self pageMargin] * 2), self.scrollView.frame.size.height - ([self pageMargin] * 2));
}

- (void) setupScrollView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.showControls = YES;
    self.scrollView = [[PageView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.pagingEnabled = YES;
    //self.scrollView.scrollEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.dataSource = self;
    [self.scrollView registerClass:[PageCell class] forCellWithReuseIdentifier:@"slideViewCell"];
    
    [self.view addSubview:self.scrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScrollView];
    self.firstPageNumber = 0;
    self.lastPageNumber = -1;
}

- (void) reloadFirstCell {
    // sets the correct progress bar for the first load
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.scrollView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
    });
}


- (void) setStartingPageNumber: (NSNumber *) startingPageNumber {
    //self.firstPageNumber = [startingPageNumber intValue];
    //self.lastPageNumber = [startingPageNumber intValue];
    _startingPageNumber = startingPageNumber;
}


- (void)loadBookmark {
    if (self.story.bookmark) {
        self.startingPageNumber = self.story.bookmark.page_number;
        self.currentPageNumber = [self.story.bookmark.page_number intValue];
        self.pageFont = [UIFont fontWithName:@"Meta Serif OT" size:[self.story.bookmark.font_size floatValue]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadBookmark];
    if ([self.startingPageNumber intValue] == 0) {
        self.startingPageNumber = nil;
    }
    [self buildAllPages];
    [self showLoadingPage];
    [self postStoryView];
    
}

- (void)postStoryView {
    StoryView *storyView = [[StoryView alloc] init];
    storyView.story_id = self.story.id;
    [RKObjectManager.sharedManager postObject:storyView path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Posted story view object: %@", [mappingResult firstObject]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error posting story view: %@", error);
    }];
}

- (void)hideAllControls {
    self.showControls = NO;
    for (PageCell *cell in self.scrollView.subviews) {
        if (cell.class == PageCell.class) [cell hideControls];
    }
}

- (void)showAllControls {
    self.showControls = YES;
    for (PageCell *cell in self.scrollView.subviews) {
        if (cell.class == PageCell.class) [cell showControls];
    }
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

- (void) scrollToPercentage:(CGFloat)percentage {
    int pageNumber = percentage * self.totalPages;
    [self scrollToPageNumber:pageNumber];
    
    PageCell *pageCell = (PageCell *)[self.scrollView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:pageNumber inSection:0]];
    [pageCell setPercentage:percentage];
}

- (void)scrollToPageNumber: (int) pageNumber {
    //if (pageNumber == self.currentPageNumber) return;
    self.currentPageNumber = pageNumber;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(pageNumber) inSection:0];
    [self.scrollView scrollToItemAtIndexPath:indexPath atScrollPosition: UICollectionViewScrollPositionLeft animated:NO];
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

- (void)scrollToCorrectPage {
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
        
        self.loadingShot.hidden = YES;
        [self.view bringSubviewToFront:self.scrollView];
        self.scrollView.alpha = 0.0;
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollView.alpha = 1.0;
        }];
    });
    //self.loadingShot.hidden = YES;
    //[self.scrollView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.pageControl.currentPage inSection:0]]];
}

- (void) buildAllPages {
    self.lastPageNumber = -1;
    if (self.stopAddingJobs) return;
    
    [self showLoadingPage];
        [self createNumberOfPages:pagesToBuffer
               startingPageNumber:@(0)
                        fromBlock:@(0)
                            index:0
                       pageBuffer:@""];
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


- (void)saveBookmark {
    if (!self.story.bookmark) {
        self.story.bookmark = [Bookmark createEntity];
        self.story.bookmark.auto_bookmark = @(YES);
    }
    
    self.story.bookmark.font_size = @(self.pageFont.pointSize);
    //bookmark.page = [self currentPage];
    self.story.bookmark.page_number = @(self.currentPageNumber);
    self.story.bookmark.story_id = self.story.id;
    [[self.story.bookmark managedObjectContext] save:nil];
    if (![self.story.bookmark.auto_bookmark boolValue]) {
        // post bookmark to backend
        [RKObjectManager.sharedManager postObject:self.story.bookmark path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"Posted bookmark: %@", [mappingResult firstObject]);
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Error posting bookmark: %@", error);
        }];
    }
}


- (void)backClicked {
    [self saveBookmark];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewPop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (Page *)currentPage {
    Page *page = [Page findFirstWithPredicate:[NSPredicate predicateWithFormat:@"page_number == %d AND story_id == %@", self.currentPageNumber, self.story.id]];
    return page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat offset = self.scrollView.contentOffset.x;
    CGFloat width = self.scrollView.frame.size.width;
    int newCurrentPage = ((offset+(width/2))/width);
    if (newCurrentPage != self.currentPageNumber) {
        if (newCurrentPage > (self.lastPageNumber - pagesToBuffer + 1)) {
            //[self getMorePages];
        } else {
            //self.stopLoadingPages = YES;
        }
    }
    self.currentPageNumber = ((offset+(width/2))/width);
    NSLog(@"current page %d", self.currentPageNumber);
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

- (void)bookmarkClicked {
    if (self.story.bookmark && ![self.story.bookmark.auto_bookmark boolValue]) {
        [self deleteBookmark];
    } else {
        [self createBookmark];
    }
}

- (void)createBookmark {
    Bookmark *newBookmark = [Bookmark createEntity];
    newBookmark.page_number = @(self.currentPageNumber);
    newBookmark.story_id = self.story.id;
    newBookmark.font_size = @(self.pageFont.pointSize);
    self.story.bookmark = newBookmark;
    
    [[self.story managedObjectContext] save:nil];
    [[newBookmark managedObjectContext] save:nil];
    // post bookmark
    [[RKObjectManager sharedManager] postObject:newBookmark path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Saved bookmark :%@", [mappingResult firstObject]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error saving bookmark: %@", error);
    }];
    [[self currentPageCell] setPageBookmarked];
}

- (void)deleteBookmark {
    NSLog(@"deleting bookmark :%@", self.story.bookmark);
    [RKObjectManager.sharedManager deleteObject:self.story.bookmark path:nil parameters:@{@"story_id": self.story.bookmark.story_id} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Deleted bookmark");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error deleting bookmark: %@", error);
    }];
    
    Story *story = self.story;
    story.bookmark = nil;
    [self.delegate deleteBookmarkedStory:story];
    [[self currentPageCell] setPageUnbookmarked];
}

- (PageCell *)currentPageCell {
    return (PageCell*)[self.scrollView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPageNumber inSection:0]];
}

#pragma mark collectionView delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.lastPageNumber + 1);
}
                                       
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PageCell *cell = [self.scrollView dequeueReusableCellWithReuseIdentifier:@"slideViewCell" forIndexPath:indexPath];
    
    [cell renderWithPageNumber:@(indexPath.row)
                       storyId:self.story.id
                          font:self.pageFont margin:[self pageMargin]
                      progress:((indexPath.row + 1) / (CGFloat)self.totalPages)
                  showControls:self.showControls];
    cell.scrollView = self.scrollView;
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.scrollView.width , self.scrollView.height);
}

@end
