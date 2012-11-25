//
//  LoginViewController.m
//  BookApp
//
//  Created by Haochen Li on 2012-11-25.
//
//

#import "LoginViewController.h"
#import "DiscoverVC.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        //initialize
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//create fb login button
    self.fbLoginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.fbLoginBtn addTarget:self
               action:@selector(fbLogin)
     forControlEvents:UIControlEventTouchDown];
    [self.fbLoginBtn setTitle:@"Facebook Login" forState:UIControlStateNormal];
    self.fbLoginBtn.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:self.fbLoginBtn];
    
    //create fake login button
    self.fakeLoginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.fakeLoginBtn addTarget:self action:@selector(fakeLogin) forControlEvents:UIControlEventTouchDown];
    [self.fakeLoginBtn setTitle:@"Fake Login" forState:UIControlStateNormal];
    self.fakeLoginBtn.frame = CGRectMake(80.0, 400.0, 160.0, 40.0);
    [self.view addSubview:self.fakeLoginBtn];
}

- (void)fbLogin
{
    NSLog(@"try fb login");
}

- (void)fakeLogin
{
    NSLog(@"try fake login");
    DiscoverVC *discoverVC = [[DiscoverVC alloc] init];
    [self.navigationController pushViewController:discoverVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
