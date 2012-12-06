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

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
	//create back button
    self.backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.backBtn addTarget:self
                        action:@selector(backPressed)
              forControlEvents:UIControlEventTouchDown];
    [self.backBtn setTitle:@"Back" forState:UIControlStateNormal];
    self.backBtn.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:self.backBtn];
    
    //create logout button
    self.logoutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.logoutBtn addTarget:self
                     action:@selector(logoutPressed)
           forControlEvents:UIControlEventTouchDown];
    [self.logoutBtn setTitle:@"Logout" forState:UIControlStateNormal];
    self.logoutBtn.frame = CGRectMake(300, 210.0, 160.0, 40.0);
    [self.view addSubview:self.logoutBtn];
    
    //first name
    self.firstName = [[UILabel alloc] initWithFrame:CGRectMake(200, 300.0, 300.0, 40.0)];
    [self.firstName setText: [NSString stringWithFormat: @"First Name: %@", appDelegate.currentUser.first_name]];
    [self.view addSubview:self.firstName];
    
    //last name
    self.lastName = [[UILabel alloc] initWithFrame:CGRectMake(200, 350, 300.0, 40.0)];
    [self.lastName setText: [NSString stringWithFormat: @"Last Name: %@", appDelegate.currentUser.last_name]];
    [self.view addSubview:self.lastName];
    
    //email
    self.email = [[UILabel alloc] initWithFrame:CGRectMake(200, 400, 300.0, 40.0)];
    [self.email setText: [NSString stringWithFormat: @"Email: %@", appDelegate.currentUser.email]];
    [self.view addSubview:self.email];
    
    //facebook id
    self.facebookId = [[UILabel alloc] initWithFrame:CGRectMake(200, 450, 300.0, 40.0)];
    [self.facebookId setText: [NSString stringWithFormat: @"FB ID: %@", appDelegate.currentUser.facebook_id]];
    [self.view addSubview:self.facebookId];
    
    //bookapp id
    self.baId = [[UILabel alloc] initWithFrame:CGRectMake(200, 450, 300.0, 40.0)];
    [self.baId setText: [NSString stringWithFormat: @"Book App User ID: %@", appDelegate.currentUser.id]];
    [self.view addSubview:self.baId];
    
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
