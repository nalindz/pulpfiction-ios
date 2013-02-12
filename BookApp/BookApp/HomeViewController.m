//
//  DiscoverVC.m
//  BookApp
//
//  Created by Nalin on 11/13/12.
//
//

#import "HomeViewController.h"
#import "ReadViewController.h"
#import "StoryCell.h"
#import "CaptureView.h"
#import "Bookmark.h"
#import "History.h"
#import "SpringboardLayout.h"
#import "SBLayout.h"
#import "ProfileViewController.h"
#import "StoryResultsGrid.h"
#import "UIButton+ResizeWithAspectRatio.h"
#import "UIView+BounceAnimate.h"

@interface HomeViewController ()

@property (nonatomic, strong) StoryResultsGrid *storyResultGrid;
@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, strong) UITextField *searchBox;
@property (nonatomic, strong) UIButton *bookmarksButton;
@property (nonatomic, strong) UIButton *homeButton;
@property (nonatomic, strong) UILabel *homeLabel;
@property (nonatomic, strong) UILabel *bookmarksLabel;
@property (nonatomic, strong) UILabel *profileLabel;
@property (nonatomic, strong) UIButton *profileButton;

@property (nonatomic, weak) UILabel *visibleButtonLabel;


@property int pageNumberToScrollTo;
@property NSString *originalDirection;

@property int lastPage;
@property int storiesOnLastPage;

@property int startScrollOffset;

@end


@implementation HomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    SBLayout *sbLayout = [[SBLayout alloc] init];
    
    self.storyResultGrid = [[StoryResultsGrid alloc] initWithFrame:self.view.bounds collectionViewLayout:sbLayout];
    self.storyResultGrid.y = 50;
    self.storyResultGrid.backgroundColor = [UIColor whiteColor];
    //self.storyResultGrid.pagingEnabled = YES;
    
    self.storyResultGrid.height = self.view.height;
    self.storyResultGrid.dataSource = self;
    self.storyResultGrid.delegate = self;
    [self.view addSubview:self.storyResultGrid];
    [self.storyResultGrid registerClass:[StoryCell class] forCellWithReuseIdentifier:@"storyCell"];
    self.storyResultGrid.showsHorizontalScrollIndicator = NO;
    
    self.stories = [[NSArray alloc] init];
    
    [self fetchStoriesWithQuery:nil];
}

- (void) search:(NSString *)searchText {
    [self fetchStoriesWithQuery:searchText];
}

- (void) bookmarksPressed {
    [RKObjectManager.sharedManager loadObjectsAtResourcePath:@"stories?type=bookmarks" delegate:self];
    [self showLabelForButton:self.bookmarksButton];
}

- (void) homePressed {
    [self fetchStoriesWithQuery:nil];
    [self showLabelForButton:self.homeButton];
}

- (void) showLabelForButton: (UIButton *)button {
    UILabel *animatingLabel;
    
    if (button == self.bookmarksButton) {
        animatingLabel = self.bookmarksLabel;
    } else if (button == self.homeButton) {
        animatingLabel = self.homeLabel;
    } else if (button == self.profileButton) {
        animatingLabel = self.profileLabel;
    }
    
    if (animatingLabel == self.visibleButtonLabel) return;
    
    [self.visibleButtonLabel hideAnimateWithDuration:0.1 offset:20];
    [animatingLabel bounceAnimateWithDuration:0.1 offset:10 bounces:1];
    self.visibleButtonLabel = animatingLabel;
    
}


- (void) profilePressed {
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profileVC animated: YES];
}


- (void) fetchStoriesWithQuery: (NSString *) query {
    NSString *resourcePath = @"stories?type=feed";
    if (query)
        resourcePath = [NSString stringWithFormat:@"%@&query=%@", resourcePath, query];
    [RKObjectManager.sharedManager loadObjectsAtResourcePath:resourcePath delegate:self];
}


- (void) objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if ([objectLoader.resourcePath hasPrefix:@"stories"]) {
        NSLog(@"The stories : %@", objects);
        self.stories = [NSArray arrayWithArray:objects];
        [self.storyResultGrid reloadData];
    }
    
    self.lastPage = self.stories.count / 9;
    self.storiesOnLastPage = self.stories.count % 9;
    if (self.storiesOnLastPage == 0) {
        self.lastPage--;
        self.storiesOnLastPage = 9;
    }
}

- (void) objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
}

# pragma mark collectionView delegate/datasource methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: why can't this shit be square?
    return CGSizeMake(256, 268);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.stories.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView { 
    return 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Story *storyToSwitchTo = [self.stories objectAtIndex:indexPath.row];
    
    
    ReadViewController *readViewController = [[ReadViewController alloc] init];
    readViewController.story = storyToSwitchTo;
    
    //StoryCell *selectedCell = (StoryCell *)[self.storyResultGrid viewWithTag:[self cellTagForIndexPath:indexPath]];
    
    [self.navigationController pushViewController: readViewController animated:YES];
    
    NSLog(@"index path: %d", indexPath.row);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Story *story = [self.stories objectAtIndex:indexPath.row];
    
    StoryCell *cell = [self.storyResultGrid dequeueReusableCellWithReuseIdentifier:@"storyCell" forIndexPath:indexPath];
    
    [cell renderWithStory:story indexPath:indexPath];
    cell.tag = indexPath.row;
    return cell;
}

- (NSInteger)cellTagForIndexPath: (NSIndexPath *) indexPath {
    return 1000 + indexPath.row;
}



# pragma mark scroll view delegate methods


- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startScrollOffset = scrollView.contentOffset.x;
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
    int currentPageNumberInt = self.startScrollOffset / scrollView.width;
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
    if (self.pageNumberToScrollTo == -1) return;
    
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
        } else if (view.tag % 3 == 2) {
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
        } else if (view.tag % 3 == 2) {
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
