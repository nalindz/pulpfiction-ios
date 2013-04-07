//
//  LoginViewController.m
//  BookApp
//
//  Created by Haochen Li on 2012-11-25.
//
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "User+Util.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "SelectUsernameViewController.h"
#import "OLGhostAlertView.h"

@interface LoginViewController ()
@property (nonatomic, strong) UIButton *facebookLoginButton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation LoginViewController

- (UIButton*) facebookLoginButton {
    if (_facebookLoginButton == nil) {
        _facebookLoginButton = [UIButton initWithImageNamed:@"fb_login_button"];
        _facebookLoginButton.centerX = self.view.center.x;
        _facebookLoginButton.y = self.view.height  * 2/3;
        [_facebookLoginButton addTarget:self action:@selector(clickedFacebookLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _facebookLoginButton;
}

- (UIActivityIndicatorView *) spinner {
    if (_spinner == nil) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _spinner;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.facebookLoginButton];
    
    
    [self openSessionWithAllowLoginUI:NO];
    if (![FBSession.activeSession isOpen]) {
        [self showLoginButton];
    }
}

- (void)showLoggingIn {
    self.facebookLoginButton.hidden = YES;
    self.spinner.center = self.facebookLoginButton.center;
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];
    
}

- (void)showLoginButton {
    [self.spinner removeFromSuperview];
    self.facebookLoginButton.hidden = NO;
}

- (void)loginWithFBUser: (NSDictionary<FBGraphUser> *) fbUser {
    [RKObjectManager.sharedManager postObject:nil path:@"/login" parameters:@{@"facebook_id": fbUser[@"id"], @"first_name": fbUser[@"first_name"], @"last_name": fbUser[@"last_name"]} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        API.sharedInstance.loggedInUser = (User *)[mappingResult firstObject];
        if (API.sharedInstance.loggedInUser.isUsernameConfirmed) {
            [self.navigationController pushViewController:[[MainViewController alloc] init] animated:YES];
        } else {
            [self.navigationController pushViewController:[[SelectUsernameViewController alloc] init] animated:YES];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self showLoginButton];
        OLGhostAlertView *alert = [[OLGhostAlertView alloc] initWithTitle:@"Could not log in. Please try again" message:nil timeout:2.0 dismissible:NO];
        alert.position = OLGhostAlertViewPositionBottom;
        [alert show];
        NSLog(@"Error logging in: %@", error);
    }];
}

- (void)clickedFacebookLogin {
    NSLog(@"try facebook login");
    [self clearCurrentUser];
    [self openSessionWithAllowLoginUI:YES];
}

- (void)fbLoginSuccess {
    NSLog(@"login success");
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *fbUser, NSError *error) {
             if (!error) {
                 [self loginWithFBUser:fbUser];
             }
         }];
    }
}

- (void)loginSuccess: (User*) user {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.currentUser = user;
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


/* FACEBOOK SECTION */

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    [self showLoggingIn];
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

@end
