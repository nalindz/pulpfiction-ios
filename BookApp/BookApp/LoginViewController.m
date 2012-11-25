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
    [self openSessionWithAllowLoginUI:YES];
}

- (void)performFakeLogin
{
    NSLog(@"try fake login");
    [self loginSuccess];
}

- (void) loginSuccess {
    NSLog(@"login success");
    DiscoverVC *discoverVC = [[DiscoverVC alloc] init];
    [self.navigationController pushViewController:discoverVC animated:YES];
}

- (void)fbLoginFailed {
    NSLog(@"facebook login failed");
    [self.navigationController popToRootViewControllerAnimated:NO];
}

/* FACEBOOK SECTION */

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    return [FBSession openActiveSessionWithReadPermissions:nil
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
            [self loginSuccess];
            
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
            [self performSelector:@selector(fbLoginFailed)
                       withObject:nil
                       afterDelay:0.5f];
        }
            break;
        default:
            break;
    }
    
    if (error) {
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


/* END OF FACEBOOK SECTION */



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
