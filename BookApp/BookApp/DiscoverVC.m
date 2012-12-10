//
//  DiscoverVC.m
//  BookApp
//
//  Created by Nalin on 11/13/12.
//
//

#import "DiscoverVC.h"
#import "ISColumnsController.h"
#import "StoryCell.h"
#import "CaptureView.h"
#import "Bookmark.h"
#import "History.h"
#import "SpringboardLayout.h"
#import "SBLayout.h"
#import "ProfileViewController.h"
#import "StoryResultsGrid.h"

@interface DiscoverVC ()

@property (nonatomic, strong) StoryResultsGrid *storyResultGrid;
@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, strong) UITextField *searchBox;
@property (nonatomic, strong) UIButton *historyButton;
@property (nonatomic, strong) UIButton *homeButton;
@property (nonatomic, strong) UIButton *profileButton;




@property int pageNumberToScrollTo;
@property NSString *originalDirection;

@end

@implementation DiscoverVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
   self.searchBox = [[UITextField alloc] initWithFrame:CGRectMake(40, 40, 100, 100)];
    
    self.searchBox.width = self.view.width * 0.6;
    self.searchBox.height = 50;
    self.searchBox.font = [UIFont fontWithName:@"MetaBoldLF-Roman" size:30];
    [self.searchBox putInRightEdgeOf:self.view withMargin:40];
    self.searchBox.returnKeyType = UIReturnKeySearch;
    self.searchBox.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.searchBox.layer.borderWidth = 1.0;
    
    
    self.homeButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.homeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.homeButton.titleLabel.font = [UIFont fontWithName:@"MetaBoldLF-Roman" size:20];
    [self.homeButton autoSizeWithText:@"home" fixedWidth:NO];
    self.homeButton.height = self.searchBox.height;
    [self.homeButton positionLeftOf:self.searchBox withMargin:30];
    [self.homeButton addTarget:self action:@selector(homePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.homeButton];
    
    self.historyButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.historyButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.historyButton.titleLabel.font = [UIFont fontWithName:@"MetaBoldLF-Roman" size:20];
    [self.historyButton autoSizeWithText:@"history" fixedWidth:NO];
    self.historyButton.height = self.searchBox.height;
    [self.historyButton positionLeftOf:self.homeButton withMargin:30];
    [self.historyButton addTarget:self action:@selector(historyPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.historyButton];
    
    self.profileButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.profileButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.profileButton.titleLabel.font = [UIFont fontWithName:@"MetaBoldLF-Roman" size:20];
    [self.profileButton autoSizeWithText:@"profile" fixedWidth:NO];
    self.profileButton.height = self.searchBox.height;
    [self.profileButton positionLeftOf:self.historyButton withMargin:30];
    [self.profileButton addTarget:self action:@selector(profilePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.profileButton];
    
    
    
    
    
    [self.searchBox addTarget:self
                  action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    SBLayout *sbLayout = [[SBLayout alloc] init];
    
    self.storyResultGrid = [[StoryResultsGrid alloc] initWithFrame:self.view.frame collectionViewLayout:sbLayout];
    self.storyResultGrid.backgroundColor = [UIColor whiteColor];
    //self.storyResultGrid.pagingEnabled = YES;
    
    [self.storyResultGrid setY:200];
    [self.storyResultGrid setHeight:(self.view.bounds.size.height - 200)];
    self.storyResultGrid.dataSource = self;
    self.storyResultGrid.delegate = self;
    [self.view addSubview:self.storyResultGrid];
    [self.storyResultGrid registerClass:[StoryCell class] forCellWithReuseIdentifier:@"storyCell"];
    self.storyResultGrid.showsHorizontalScrollIndicator = NO;
    
    self.stories = [[NSArray alloc] init];
    
    NSLog(@"the width: %f", self.storyResultGrid.frame.size.width);
    
    
    [self fetchStoriesWithQuery:nil];
}

- (void) textFieldFinished: (id) sender {
    [self fetchStoriesWithQuery:self.searchBox.text];
}

- (void) historyPressed {
    [RKObjectManager.sharedManager loadObjectsAtResourcePath:@"history" delegate:self];
}

- (void) homePressed {
    [self fetchStoriesWithQuery:nil];
}

- (void) profilePressed {
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profileVC animated: YES];
}


- (void) fetchStoriesWithQuery: (NSString *) query {
    NSString *resourcePath = @"stories";
    if (query != nil) {
        resourcePath = [NSString stringWithFormat:@"%@?query=%@", resourcePath, query];
    }
    [RKObjectManager.sharedManager loadObjectsAtResourcePath:resourcePath delegate:self];
}


- (void) objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if ([objectLoader.resourcePath hasPrefix:@"stories"] || [objectLoader.resourcePath hasPrefix:@"history"]) {
        NSLog(@"The stories : %@", objects);
        self.stories = [NSArray arrayWithArray:objects];
        [self.storyResultGrid reloadData];
    }
}

- (void) objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
}

# pragma mark collectionView delegate/datasource methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
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
    
    
    ISColumnsController *readViewController = [[ISColumnsController alloc] init];
    readViewController.story = storyToSwitchTo;
    
    //StoryCell *selectedCell = (StoryCell *)[self.storyResultGrid viewWithTag:[self cellTagForIndexPath:indexPath]];
    
    
    Bookmark *bookmark = [Bookmark findFirstWithPredicate:[NSPredicate predicateWithFormat:@"story_id == %@ AND auto_bookmark == %@", storyToSwitchTo.id, @(YES)]];
    if (bookmark.page != nil) {
        readViewController.startingPageNumber = bookmark.page.page_number;
    }
    
    
    [self addToHistory: storyToSwitchTo.id];
    
   [self.navigationController pushViewController: readViewController animated:YES];
    
    NSLog(@"index path: %d", indexPath.row);
    
}


- (void)addToHistory: (NSNumber *) story_id {
    History *newHistory = [[History alloc] init];
    newHistory.story_id = story_id;
    
    [[RKObjectManager sharedManager]  postObject:newHistory delegate:self];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
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


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat currentPageNumberFloat = scrollView.contentOffset.x / scrollView.width;
    NSLog(@"The veloctiy: %f", velocity.x);
    NSLog(@"The veloctiy: %f", velocity.y);
    int currentPageNumberInt = scrollView.contentOffset.x / scrollView.width;
    if ( velocity.x > 0.0) {
        currentPageNumberInt++;
    } else if (velocity.x < 0 ) {
        currentPageNumberInt = currentPageNumberInt;
    } else if (currentPageNumberFloat - currentPageNumberInt > 0.2) {
        currentPageNumberInt++;
    }
    
    self.pageNumberToScrollTo = currentPageNumberInt;
    if (targetContentOffset->x < scrollView.contentOffset.x) {
        self.originalDirection = @"forward";
    } else {
        self.originalDirection = @"backward";
    }
    
    
    targetContentOffset->x = scrollView.contentOffset.x;
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) return;
    NSLog(@"meow");
    NSLog(@"page to scroll to :%d", self.pageNumberToScrollTo);
    int currentPageNumberInt = scrollView.contentOffset.x / scrollView.width;
    CGFloat xToScrollTo = self.pageNumberToScrollTo * scrollView.width;
    if (xToScrollTo > (scrollView.contentSize.width - scrollView.width)) {
        xToScrollTo = (self.pageNumberToScrollTo  - 1 ) * scrollView.width;
    }
    
    NSMutableArray *visibleViews = [[NSMutableArray alloc] init];
    for (UIView *view in scrollView.subviews) {
        CGRect targetVisibleFrame = CGRectMake(self.pageNumberToScrollTo * scrollView.width, 0, scrollView.width, scrollView.height);
        if (CGRectIntersectsRect(view.frame, targetVisibleFrame)) {
            [visibleViews addObject:view];
        }
    }
    
    NSString *adjustedDirection;
    if (self.pageNumberToScrollTo - currentPageNumberInt > 0) {
        NSLog(@"Scrolling forward");
        adjustedDirection = @"forward";
    } else {
        NSLog(@"Scrolling backwards");
        adjustedDirection = @"backward";
    }
    
    
    [scrollView scrollRectToVisible:CGRectMake(xToScrollTo, 0, scrollView.width, scrollView.height) animated:YES];
    
    
    if ([self.originalDirection isEqualToString:@"backward"] && [adjustedDirection isEqualToString:@"backward"]) {
        int i = 0;
        CGFloat duration;
        for (UIView *view in visibleViews) {
            NSLog(@"row: %d", view.tag);
            //NSLog(@"MOEW: %d", 5 % 3);
            int xShakeAmount;
            if (view.tag % 3 == 0) {
                xShakeAmount = 20;
                duration = 0.4;
            } else if (view.tag % 3 == 1) {
                xShakeAmount = 30;
                duration = 0.2;
            } else if (view.tag % 3 == 2) {
                xShakeAmount = 50;
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
    
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"woof");
}


@end
