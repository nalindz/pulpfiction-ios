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
#import "UploadStoryTutorialView.h"

@interface ProfileViewController ()
@property (nonatomic, strong) ProfileHeaderView *profileHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) UploadStoryTutorialView *uploadStoryTutorialView;
@end

#define profileHeaderHeight 60
@implementation ProfileViewController

- (void)setFirstResponder: (id) firstResponder {
    _firstResponder = firstResponder;
}

- (void)removeFirstResponder {
    _firstResponder = nil;
}

- (UploadStoryTutorialView*) uploadStoryTutorialView {
    if (_uploadStoryTutorialView == nil) {
        _uploadStoryTutorialView = [[UploadStoryTutorialView alloc] initWithFrame:self.view.bounds];
    }
    return _uploadStoryTutorialView;
}

- (ProfileHeaderView *) profileHeaderView {
    if (_profileHeaderView == nil) {
        _profileHeaderView = [[ProfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, profileHeaderHeight)];
        [_profileHeaderView render];
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

- (id)init {
    self = [super init];
    if (self) {
        self.tableData = [NSMutableArray array];
        [self.view addSubview:self.profileHeaderView];
        [self.tableView putBelow:self.profileHeaderView withMargin:0];
        self.tableView.height = self.view.height - self.tableView.y;
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchStoriesWithQuery:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    self.tableView.height = self.parentViewController.view.height - self.tableView.y - self.view.y;
}

- (void)tabButtonPressed {
    [self fetchStoriesWithQuery:nil];
    [self updateUserHeader];
}

- (void)updateUserHeader {
    [RKObjectManager.sharedManager
     getObjectsAtPath:@"/users" parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         API.sharedInstance.loggedInUser = [mappingResult firstObject];
         [self.profileHeaderView render];
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         NSLog(@"Error trying to pull new user object:%@", error);
     }];
}

- (void)search:(NSString *)searchText {
    [self fetchStoriesWithQuery:searchText];
}

- (void)fetchStoriesWithQuery: (NSString *) query {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"type": @"profile"}];
    if (query) params[@"query"] = query;
    
    [RKObjectManager.sharedManager
     getObjectsAtPath:@"/stories"
     parameters:params
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         [self receivePage:[mappingResult array]];
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         NSLog(@"Error while trying to fetch profile stories: %@", error);
     }];
}

- (void)logoutPressed {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Not done yet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)showBlankSlate {
    self.tableView.hidden = YES;
    [self.view addSubview:self.uploadStoryTutorialView];
}

- (void)hideBlankSlate {
    self.tableView.hidden = NO;
    [self.uploadStoryTutorialView removeFromSuperview];
}

- (void)receivePage: (NSArray *)objects {
    NSLog(@"Received stories: %@", objects);
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:objects];
    if (self.tableData.count == 0) {
        return [self showBlankSlate];
    } else {
        [self hideBlankSlate];
    }
    [self.tableView reloadData];
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
