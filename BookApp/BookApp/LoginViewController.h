//
//  LoginViewController.h
//  BookApp
//
//  Created by Haochen Li on 2012-11-25.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <RKObjectLoaderDelegate>

@property (strong, nonatomic) UIButton *fbLoginBtn;
@property (strong, nonatomic) UIButton *fakeLoginBtn;

@end
