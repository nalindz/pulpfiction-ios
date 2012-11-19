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

@interface DiscoverVC ()

@property (nonatomic, strong) UICollectionView *storiesResults;
@property (nonatomic, strong) NSArray *stories;
@end

@implementation DiscoverVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = @"meow nigga";
    [self.view addSubview:label];
    
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    
    
    self.storiesResults = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.storiesResults.backgroundColor = [UIColor whiteColor];
    [self.storiesResults setCollectionViewLayout:flowLayout];
    self.storiesResults.pagingEnabled = YES;
    
    [self.storiesResults setY:200];
    [self.storiesResults setHeight:(self.view.bounds.size.height - 200)];
    self.storiesResults.dataSource = self;
    self.storiesResults.delegate = self;
    [self.view addSubview:self.storiesResults];
    [self.storiesResults registerClass:[StoryCell class] forCellWithReuseIdentifier:@"storyCell"];
    
    self.stories = [[NSArray alloc] init];
    
    NSLog(@"the width: %f", self.storiesResults.frame.size.width);
    
    
    [self fetchStories];
}

- (void) fetchStories {
    [RKObjectManager.sharedManager loadObjectsAtResourcePath:@"stories" delegate:self];
}


- (void) objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"The stories : %@", objects);
    self.stories = [NSArray arrayWithArray:objects];
    [self.storiesResults reloadData];
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
    
    
   [self.navigationController pushViewController: readViewController animated:YES];
    
    NSLog(@"index path: %d", indexPath.row);
    
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