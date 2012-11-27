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

@interface DiscoverVC ()

@property (nonatomic, strong) UICollectionView *storiesResults;
@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, strong) UITextField *searchBox;
@property (nonatomic, strong) UIButton *historyButton;
@property (nonatomic, strong) UIButton *homeButton;
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
    
    
    
    
    
    [self.searchBox addTarget:self
                  action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    SBLayout *sbLayout = [[SBLayout alloc] init];
    
    self.storiesResults = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:sbLayout];
    self.storiesResults.backgroundColor = [UIColor whiteColor];
    self.storiesResults.pagingEnabled = YES;
    
    [self.storiesResults setY:200];
    [self.storiesResults setHeight:(self.view.bounds.size.height - 200)];
    self.storiesResults.dataSource = self;
    self.storiesResults.delegate = self;
    [self.view addSubview:self.storiesResults];
    [self.storiesResults registerClass:[StoryCell class] forCellWithReuseIdentifier:@"storyCell"];
    self.storiesResults.showsHorizontalScrollIndicator = NO;
    
    self.stories = [[NSArray alloc] init];
    
    NSLog(@"the width: %f", self.storiesResults.frame.size.width);
    
    
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
        [self.storiesResults reloadData];
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
    
    //StoryCell *selectedCell = (StoryCell *)[self.storiesResults viewWithTag:[self cellTagForIndexPath:indexPath]];
    
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
    
    StoryCell *cell = [self.storiesResults dequeueReusableCellWithReuseIdentifier:@"storyCell" forIndexPath:indexPath];
    
    
    [cell renderWithStory:story indexPath:indexPath];
    cell.tag = [self cellTagForIndexPath: indexPath];
    return cell;
}

- (NSInteger)cellTagForIndexPath: (NSIndexPath *) indexPath {
    return 1000 + indexPath.row;
}

@end