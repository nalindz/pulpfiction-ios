//
//  AppDelegate.h
//  BookApp
//
//  Created by Nalin on 11/1/12.
//
//

#import <UIKit/UIKit.h>
#import "ISColumnsController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (retain, nonatomic) UINavigationController *navigationController;
@property (retain, nonatomic) ISColumnsController *columnsController;
@end
