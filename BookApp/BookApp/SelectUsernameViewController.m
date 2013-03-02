//
//  SelectUsernameViewController.m
//  BookApp
//
//  Created by Nalin on 2/27/13.
//
//

#import "SelectUsernameViewController.h"

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
    
}
@end
