//
//  HomeViewController.m
//  BookApp
//
//  Created by Nalin on 11/13/12.
//
//

#import "HomeViewController.h"
#import "StoryCell.h"
#import "CaptureView.h"
#import "Bookmark.h"
#import "SpringboardLayout.h"
#import "SBLayout.h"
#import "ProfileViewController.h"
#import "UIButton+ResizeWithAspectRatio.h"
#import "UIView+BounceAnimate.h"

@interface HomeViewController ()
#define pageSize 18
@property (nonatomic, strong) UICollectionView *storyResultGrid;
@property (nonatomic, strong) UIView *bookmarksBlankSlateView;
@property (nonatomic, weak) NSMutableArray *stories;
@property (nonatomic, strong) NSMutableArray *feedStories;
@property (nonatomic, strong) NSMutableArray *bookmarkStories;
@property (nonatomic, weak) UILabel *visibleButtonLabel;

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic) int currentPageNumber;
@property (atomic) BOOL isLoadingPage;
@property (atomic) BOOL canStartPaginateRequest;

@property (atomic) BOOL isFeedView;
@property (atomic) BOOL endOfFeed;

// animation stuff
@property int pageNumberToScrollTo;
@property NSString *originalDirection;
@property int lastPage;
@property int storiesOnLastPage;
@property int startScrollOffset;

@end


@implementation HomeViewController

- (UIView*) bookmarksBlankSlateView {
    if (_bookmarksBlankSlateView == nil) {
        _bookmarksBlankSlateView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmarks_blank_slate"]];
    }
    return _bookmarksBlankSlateView;
}

- (NSMutableArray*)feedStories {
    if (_feedStories == nil) {
        _feedStories = [NSMutableArray array];
    }
    return _feedStories;
}

- (NSMutableArray *)bookmarkStories {
    if (_bookmarkStories == nil) {
        _bookmarkStories = [NSMutableArray array];
    }
    return _bookmarkStories;
}

- (id)initWithFrame: (CGRect) frame {
    self = [super init];
    if (self) {
        self.view.frame = frame;
    }
    return self;
}

- (UICollectionView*) storyResultGrid {
    if (_storyResultGrid == nil) {
        SBLayout *sbLayout = [[SBLayout alloc] initWithBounds:self.view.bounds];
        _storyResultGrid = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:sbLayout];
        _storyResultGrid.y = 0;
        _storyResultGrid.backgroundColor = [UIColor whiteColor];
        //_storyResultGrid.pagingEnabled = YES;
        _storyResultGrid.height = self.view.height;
        _storyResultGrid.dataSource = self;
        _storyResultGrid.delegate = self;
        _storyResultGrid.bounces = YES;
        
        [_storyResultGrid registerClass:[StoryCell class] forCellWithReuseIdentifier:@"storyCell"];
        _storyResultGrid.showsHorizontalScrollIndicator = NO;
    }
    return _storyResultGrid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.canStartPaginateRequest = YES;
    self.currentPageNumber = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.view addSubview:self.storyResultGrid];
}

- (void)search:(NSString *)searchText {
    self.searchText = searchText;
    [self fetchFeedPage:1 withQuery:searchText];
}

- (void)bookmarksPressed {
    self.isFeedView = NO;
    self.stories = self.bookmarkStories;
    [self.storyResultGrid reloadData];
    [self fetchBookmarkStories];
}

- (void)homePressed {
    self.isFeedView = YES;
    self.stories = self.feedStories;
    [self.storyResultGrid reloadData];
}

- (void)resetFeedState {
    self.endOfFeed = NO;
    self.canStartPaginateRequest = YES;
}

- (void)fetchBookmarkStories {
    [RKObjectManager.sharedManager
     getObjectsAtPath:@"/stories"
     parameters:@{@"type": @"bookmarks"}
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         [self receivePageofStories:[mappingResult array] ofType:@"bookmarks" pageNumber:1];
         [self scrollToFirstPageAnimated:NO];
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         NSLog(@"Error loading bookmarks: %@", error);
     }];
}

- (void)fetchFeedPage: (int) pageNumber withQuery: (NSString *) query {
    if (pageNumber == 1) {
        [self resetFeedState];
    }
    if (!self.canStartPaginateRequest && pageNumber != 1) return;
    if (self.isLoadingPage) return;
    if (self.endOfFeed) return;
    self.isLoadingPage = YES;
    self.canStartPaginateRequest = NO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"type": @"feed", @"page": @(pageNumber)}];
    query = [query trim];
    if (query && ![query isBlank]) params[@"query"] = query;
    
    [RKObjectManager.sharedManager
     getObjectsAtPath:@"/stories"
     parameters:params
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         NSArray *storiesPage = [mappingResult array];
         [self receivePageofStories:storiesPage ofType:@"feed" pageNumber:pageNumber];
         
         if (storiesPage.count == pageSize) {
             self.currentPageNumber = pageNumber;
         } else {
             self.endOfFeed = YES;
         }
         self.isLoadingPage = NO;
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         NSLog(@"Error loading feed: %@", error);
         self.isLoadingPage = NO;
     }];
}

- (void)showFeedBlankSlate {
}

- (void)hideFeedBlankSlate {
}

- (void)hideAllBlankSlates {
    [self hideBookmarksBlankSlate];
    [self hideFeedBlankSlate];
    self.storyResultGrid.hidden = NO;
}

- (void)showBookmarksBlankSlate {
    self.storyResultGrid.hidden = YES;
    [self.view addSubview:self.bookmarksBlankSlateView];
    self.bookmarksBlankSlateView.center = self.storyResultGrid.center;
}

- (void)hideBookmarksBlankSlate {
    [self.bookmarksBlankSlateView removeFromSuperview];
}

- (void)receivePageofStories: (NSArray *)stories ofType: (NSString *) type pageNumber: (int) pageNumber {
    if (pageNumber == 1) [self.stories removeAllObjects];
    [self.stories addObjectsFromArray:stories];
    [self.storyResultGrid reloadData];
    
    if (self.stories.count == 0) {
        if ([type isEqualToString:@"feed"]) {
            [self showFeedBlankSlate];
            [self hideBookmarksBlankSlate];
        } else if ([type isEqualToString:@"bookmarks"]) {
            [self showBookmarksBlankSlate];
            [self hideFeedBlankSlate];
        }
    } else {
        [self hideAllBlankSlates];
    }
    
    self.lastPage = self.stories.count / 9;
    self.storiesOnLastPage = self.stories.count % 9;
    if (self.storiesOnLastPage == 0) {
        self.lastPage--;
        self.storiesOnLastPage = 9;
    }
}

- (void)deleteBookmarkedStory:(Story *)bookmarkedStory {
    int i = 0;
    for (Story *story in self.bookmarkStories) {
        if ([story.id isEqualToNumber:bookmarkedStory.id]) {
            [self.bookmarkStories removeObjectAtIndex:i];
            [self.storyResultGrid reloadData];
            break;
        }
    i++;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.stories.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Story *storyToSwitchTo = [self.stories objectAtIndex:indexPath.row];
    [Log eventName:@"clicked_story" data:@{@"story_id": storyToSwitchTo.id}];
    ReadViewController *readViewController = [[ReadViewController alloc] init];
    readViewController.delegate = self;
    readViewController.storyId = storyToSwitchTo.id;
    [self.navigationController pushViewController: readViewController animated:YES];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Story *story = [self.stories objectAtIndex:indexPath.row];
    StoryCell *cell = [self.storyResultGrid dequeueReusableCellWithReuseIdentifier:@"storyCell" forIndexPath:indexPath];
    [cell renderWithStory:story indexPath:indexPath];
    cell.tag = indexPath.row;
    return cell;
}

# pragma mark scroll view delegate methods

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startScrollOffset = scrollView.contentOffset.x;
    self.canStartPaginateRequest = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat currentPageNumberFloat = scrollView.contentOffset.x / scrollView.width;
    int currentPageNumberInt = scrollView.contentOffset.x / scrollView.width;
    if ( velocity.x > 0.0) {
        currentPageNumberInt++;
    } else if (velocity.x < 0 ) {
        currentPageNumberInt = currentPageNumberInt;
    } else if (currentPageNumberFloat - currentPageNumberInt > 0.2) {
        currentPageNumberInt++;
    }
    
    self.pageNumberToScrollTo = currentPageNumberInt;
    if (scrollView.contentOffset.x > self.startScrollOffset) {
        self.originalDirection = @"forward";
    } else {
        self.originalDirection = @"backward";
    }
    
    //NSLog(@"Original direction :%@", self.originalDirection);
    targetContentOffset->x = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) return;
    //NSLog(@"page to scroll to :%d", self.pageNumberToScrollTo);
    //int currentPageNumberInt = self.startScrollOffset / scrollView.width;
    //NSLog(@"current Page number :%d", currentPageNumberInt);
    CGFloat xToScrollTo = self.pageNumberToScrollTo * scrollView.width;
    if (xToScrollTo > (scrollView.contentSize.width - scrollView.width)) {
        xToScrollTo = (self.pageNumberToScrollTo  - 1 ) * scrollView.width;
    }
    
    [scrollView scrollRectToVisible:CGRectMake(xToScrollTo, 0, scrollView.width, scrollView.height) animated:YES];
    
    [self performAnimationsForScrollView:scrollView scrollingFinished:NO];
}

- (void)performAnimationsForScrollView: (UIScrollView *) scrollView scrollingFinished: (BOOL) scrollingFinished {
    NSMutableArray *visibleViews = [[NSMutableArray alloc] init];
    for (UIView *view in scrollView.subviews) {
        CGRect targetVisibleFrame = CGRectMake(self.pageNumberToScrollTo * scrollView.width, 0, scrollView.width, scrollView.height);
        if (CGRectIntersectsRect(view.frame, targetVisibleFrame)) {
            [visibleViews addObject:view];
        }
    }
    
    int currentPageNumberInt = self.startScrollOffset / scrollView.width;
    NSString *adjustedDirection;
    if (self.pageNumberToScrollTo == currentPageNumberInt) {
        adjustedDirection = @"same";
    } else if (self.pageNumberToScrollTo - currentPageNumberInt > 0) {
        adjustedDirection = @"forward";
    } else {
        adjustedDirection = @"backward";
    }
    
    //NSLog(@"adjusted direction %@", adjustedDirection);
    
    if (([self.originalDirection isEqualToString:@"backward"] && [adjustedDirection isEqualToString:@"same"])) {
        if (!scrollingFinished)
            [self animateBackward: visibleViews];
    } else if (([self.originalDirection isEqualToString:@"forward"] && [adjustedDirection isEqualToString:@"same"])) {
        if (!scrollingFinished)
            [self animateBackward: visibleViews];
    }
    
    /*
    
    if (([self.originalDirection isEqualToString:@"backward"] && [adjustedDirection isEqualToString:@"same"])
     || ([self.originalDirection isEqualToString:@"backward"] && [adjustedDirection isEqualToString:@"forward"])) {
        if (!scrollingFinished)
            [self animateBackward: visibleViews];
    } else if ([self.originalDirection isEqualToString:@"forward"] && [adjustedDirection isEqualToString:@"forward"]) {
        if (scrollingFinished)
           [self animateForward: visibleViews];
     
    } else if ([self.originalDirection isEqualToString:@"backward"] && [adjustedDirection isEqualToString:@"backward"]) {
        if (scrollingFinished)
            [self animateForward: visibleViews];
    }
     */
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.pageNumberToScrollTo = -1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //if (self.pageNumberToScrollTo == -1) return;
    
    NSMutableArray *visibleViews = [[NSMutableArray alloc] init];
    for (UIView *view in scrollView.subviews) {
        CGRect targetVisibleFrame = CGRectMake(self.pageNumberToScrollTo * scrollView.width, 0, scrollView.width, scrollView.height);
        if (CGRectIntersectsRect(view.frame, targetVisibleFrame)) {
            [visibleViews addObject:view];
        }
    }
    
    if (visibleViews.count >= 9 || (self.pageNumberToScrollTo == self.lastPage && visibleViews.count >= self.storiesOnLastPage)) {
        [self performAnimationsForScrollView:scrollView scrollingFinished:YES];
        self.pageNumberToScrollTo = -1;
    }
    
    
    if ((scrollView.contentSize.width - (scrollView.contentOffset.x + scrollView.width) < scrollView.width / 2) && self.isFeedView) {
        [self fetchNextPage];
    }
}

- (void)scrollToFirstPageAnimated: (BOOL) animated {
    [self.storyResultGrid scrollRectToVisible:CGRectMake(0, 0, self.storyResultGrid.width, self.storyResultGrid.height) animated:animated];
}

- (void)fetchNextPage {
    [self fetchFeedPage:(self.currentPageNumber + 1) withQuery:self.searchText];
}

- (void)animateForward: (NSArray *) visibleViews {
    //NSLog(@"ANImate forward");
    int i = 0;
    CGFloat duration;
    for (UIView *view in visibleViews) {
        //NSLog(@"MOEW: %d", 5 % 3);
        int xShakeAmount;
        if (view.tag % 3 == 0) {
            xShakeAmount = 10;
            duration = 0.4;
        } else if (view.tag % 3 == 1) {
            xShakeAmount = 20;
            duration = 0.2;
        } else {
            xShakeAmount = 30;
            duration = 0.1;
        }
        
        [UIView animateWithDuration:duration
                         animations:^{
                             view.x -= xShakeAmount;
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3 animations:^{
                                 view.x += xShakeAmount;
                             }];
                         }];
        i++;
    }
}

- (void)animateBackward: (NSArray *) visibleViews {
    //NSLog(@"ANImate backward");
    int i = 0;
    CGFloat duration;
    for (UIView *view in visibleViews) {
        int xShakeAmount;
        if (view.tag % 3 == 0) {
            xShakeAmount = 30;
            duration = 0.4;
        } else if (view.tag % 3 == 1) {
            xShakeAmount = 20;
            duration = 0.2;
        } else {
            xShakeAmount = 10;
            duration = 0.1;
        }
        
        [UIView animateWithDuration:duration
                         animations:^{
                             view.x -= xShakeAmount;
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3 animations:^{
                                 view.x += xShakeAmount;
                             }];
                         }];
        i++;
    }
    
}

@end
