//
//  LoginViewController.m
//  BookApp
//
//  Created by Haochen Li on 2012-11-25.
//
//

#import "LoginViewController.h"
#import "DiscoverVC.h"
#import "AppDelegate.h"
#import "User.h"
#import "AppDelegate.h"

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
               action:@selector(performFbLogin)
     forControlEvents:UIControlEventTouchDown];
    [self.fbLoginBtn setTitle:@"Facebook Login" forState:UIControlStateNormal];
    self.fbLoginBtn.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:self.fbLoginBtn];
    
    //create fake login button
    self.fakeLoginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.fakeLoginBtn addTarget:self action:@selector(performFakeLogin) forControlEvents:UIControlEventTouchDown];
    [self.fakeLoginBtn setTitle:@"Fake Login" forState:UIControlStateNormal];
    self.fakeLoginBtn.frame = CGRectMake(80.0, 400.0, 160.0, 40.0);
    [self.view addSubview:self.fakeLoginBtn];
}

- (void)performFbLogin
{
    NSLog(@"try facebook login");
    [self clearCurrentUser];
    [self openSessionWithAllowLoginUI:YES];
}

- (void)performFakeLogin
{
    NSLog(@"try fake login");
    [self clearCurrentUser];
    [self fetchUserWithUserId:@"1"];
}

- (void)fbLoginSuccess {
    NSLog(@"login success");
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 NSString *firstName = [user objectForKey:@"first_name"];
                 NSString *lastName = [user objectForKey:@"last_name"];
                 NSString *facebookId = [user objectForKey:@"id"];
                 NSString *email = [user objectForKey:@"email"];
                 [self fetchUserWithFacebookId:facebookId andFirstName:firstName andLastName:lastName andEmail: email];
             }
         }];
    }
}

- (void)loginSuccess: (User*) user {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.currentUser = user;
    DiscoverVC *discoverVC = [[DiscoverVC alloc] init];
    [self.navigationController pushViewController:discoverVC animated:YES];
}

- (void)fbLoginFailed {
    NSLog(@"facebook login failed");
    [self clearCurrentUser];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)clearCurrentUser{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.currentUser = nil;
}

/* RESTKIT SECTION */

- (void) fetchUserWithUserId: (NSString *) userId {
    NSString *resourcePath = @"users";
    if (userId != nil) {
        resourcePath = [NSString stringWithFormat:@"%@?id=%@", resourcePath, userId];
    }
    [RKObjectManager.sharedManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

- (void) fetchUserWithFacebookId: (NSString *) facebookId andFirstName: (NSString *) firstName andLastName: (NSString*) lastName andEmail:(NSString*) email{
    NSString *resourcePath = @"users";
    if (facebookId != nil) {
        resourcePath = [NSString stringWithFormat:@"%@?facebook_id=%@&first_name=%@&last_name=%@&email=%@", resourcePath, facebookId, firstName, lastName, email];
    }
    [RKObjectManager.sharedManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object{
    if ([objectLoader.resourcePath hasPrefix:@"users"]) {
        NSLog(@"The user : %@", object);
        [self loginSuccess:object];
    }
}

- (void) objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
}

/* FACEBOOK SECTION */

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", nil];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             [self sessionStateChanged:session state:state error:error];
                                         }];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
{
    // FBSample logic
    // Any time the session is closed, we want to display the login controller (the user
    // cannot use the application unless they are logged in to Facebook). When the session
    // is opened successfully, hide the login controller and show the main UI.
    switch (state) {
        case FBSessionStateOpen: {
            [self fbLoginSuccess];
            
            // FBSample logic
            // Pre-fetch and cache the friends for the friend picker as soon as possible to improve
            // responsiveness when the user tags their friends.
            //FBCacheDescriptor *cacheDescriptor = [FBFriendPickerViewController cacheDescriptor];
            //[cacheDescriptor prefetchAndCacheForSession:session];
        }
            break;
        case FBSessionStateClosed: {
            // FBSample logic
            // Once the user has logged out, we want them to be looking at the root view.            
            [FBSession.activeSession closeAndClearTokenInformation];
            [self clearCurrentUser];
            [self performSelector:@selector(fbLoginFailed)
                       withObject:nil
                       afterDelay:0.5f];
        }
            break;
        case FBSessionStateClosedLoginFailed: {
            // if the token goes invalid we want to switch right back to
            // the login view, however we do it with a slight delay in order to
            // account for a race between this and the login view dissappearing
            // a moment before
            [self clearCurrentUser];
            [self performSelector:@selector(fbLoginFailed)
                       withObject:nil
                       afterDelay:0.5f];
        }
            break;
        default:
            break;
    }
    
    if (error) {
        [self clearCurrentUser];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %@",
                                                                     [self FBErrorCodeDescription:error.code]]
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (NSString *)FBErrorCodeDescription:(FBErrorCode) code {
    switch(code){
        case FBErrorInvalid :{
            return @"FBErrorInvalid";
        }
        case FBErrorOperationCancelled:{
            return @"FBErrorOperationCancelled";
        }
        case FBErrorLoginFailedOrCancelled:{
            return @"FBErrorLoginFailedOrCancelled";
        }
        case FBErrorRequestConnectionApi:{
            return @"FBErrorRequestConnectionApi";
        }case FBErrorProtocolMismatch:{
            return @"FBErrorProtocolMismatch";
        }
        case FBErrorHTTPError:{
            return @"FBErrorHTTPError";
        }
        case FBErrorNonTextMimeTypeReturned:{
            return @"FBErrorNonTextMimeTypeReturned";
        }
        case FBErrorNativeDialog:{
            return @"FBErrorNativeDialog";
        }
        default:
            return @"[Unknown]";
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
