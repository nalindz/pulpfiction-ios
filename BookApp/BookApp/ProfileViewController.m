//
//  ProfileViewController.m
//  BookApp
//
//  Created by Haochen Li on 2012-11-26.
//
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "ProfileHeaderView.h"
#import "ProfileStoryCell.h"

@interface ProfileViewController ()
@property (nonatomic, strong) ProfileHeaderView *profileHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableData;
@end

#define profileHeaderHeight 50
@implementation ProfileViewController

- (void) setFirstResponder: (id) firstResponder {
    _firstResponder = firstResponder;
}

- (ProfileHeaderView *) profileHeaderView {
    if (_profileHeaderView == nil) {
        _profileHeaderView = [[ProfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, profileHeaderHeight)];
        _profileHeaderView.delegate = self;
    }
    return _profileHeaderView;
}


- (UITableView *) tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}

- (id)init
{
    self = [super init];
    if (self) {
        //[self.view addSubview:self.profileView];
        self.tableData = [NSMutableArray array];
        [self.view addSubview:self.profileHeaderView];
        [self.tableView putBelow:self.profileHeaderView withMargin:0];
        self.tableView.height = self.view.height - self.tableView.y;
        [self.profileHeaderView setUsername:@"nalin"];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Story *story = [self.tableData objectAtIndex:indexPath.row];
    return [ProfileStoryCell cellHeight];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Story *story = [self.tableData objectAtIndex:indexPath.row];
    NSString *cellIdentifier = @"ProfileStoryCell";
    
    ProfileStoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[ProfileStoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    [cell renderWithStory:story];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchStoriesWithQuery:nil];
}

- (void)search:(NSString *)searchText {
    [self fetchStoriesWithQuery:searchText];
}

- (void)fetchStoriesWithQuery: (NSString *) query {
    NSString *resourcePath = @"stories?type=profile";
    if (query)
        resourcePath = [NSString stringWithFormat:@"%@&query=%@", resourcePath, query];
    [RKObjectManager.sharedManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

- (void)logoutPressed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Not done yet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"Received stories: %@", objects);
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:objects];
    [self.tableView reloadData];
}

- (void) objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Error while trying to fetch profile stories: %@", error);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.firstResponder isFirstResponder] && [touch view] != self.firstResponder) {
        [self.firstResponder resignFirstResponder];
        self.firstResponder = nil;
    }
    [super touchesBegan:touches withEvent:event];
}

@end
