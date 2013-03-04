//
//  SelectUsernameViewController.m
//  BookApp
//
//  Created by Nalin on 2/27/13.
//
//

#import "SelectUsernameViewController.h"
#import "MainViewController.h"

@interface SelectUsernameViewController()
@property (nonatomic, strong) SelectUsernameView *selectUsernameView;
@end

@implementation SelectUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectUsernameView = [[SelectUsernameView alloc] initWithFrame:self.view.bounds];
    [self.selectUsernameView setSuggestedUsername:[API sharedInstance].loggedInUser.username];
    self.selectUsernameView.delegate = self;
    self.view = self.selectUsernameView;
}

- (void)userNameSelected:(NSString *)username {
    [API sharedInstance].loggedInUser.username = username;
    [RKObjectManager.sharedManager
     putObject:[API sharedInstance].loggedInUser
     path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         NSLog(@"Username updated");
         MainViewController *mainViewController = [[MainViewController alloc] init];
        [self.navigationController pushViewController:mainViewController animated:YES];
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error while updating username: %@", error);
    }];
    
}

@end
