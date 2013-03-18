//
//  MainViewController.h
//  BookApp
//
//  Created by Nalin on 2/9/13.
//
//

#import <UIKit/UIKit.h>

@protocol MainViewControllerDelegate
@optional
- (void)tabButtonPressed;
@end

@interface MainViewController : UIViewController
@end