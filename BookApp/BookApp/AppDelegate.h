//
//  AppDelegate.h
//  BookApp
//
//  Created by Nalin on 11/1/12.
//
//

#import <UIKit/UIKit.h>
#import "ReadViewController.h"

@class User;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) UINavigationController *navigationController;
@property (retain, nonatomic) ReadViewController *columnsController;
@property (retain, nonatomic) User *currentUser;
@end
