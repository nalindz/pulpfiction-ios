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
#import "ProfileView.h"
#import "ProfileStoryCell.h"

@interface ProfileViewController ()
@property (nonatomic, strong) ProfileView *profileView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableData;
@end

@implementation ProfileViewController


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
        self.profileView = [[ProfileView alloc] initWithFrame:self.view.bounds];
        //[self.view addSubview:self.profileView];
        self.tableData = [NSMutableArray array];
        [self.view addSubview:self.tableView];
        [self.profileView setUsername:@"nalin"];
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
    [cell renderWithStory:story];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchStories];
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetchStories {
    [RKObjectManager.sharedManager loadObjectsAtResourcePath:@"stories?type=profile" delegate:self];
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
    [self.tableData addObjectsFromArray:objects];
    [self.tableView reloadData];
}

- (void) objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Error while trying to fetch profile stories: %@", error);
}

@end
