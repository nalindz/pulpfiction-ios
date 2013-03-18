//
//  HomeViewController.h
//  BookApp
//
//  Created by Nalin on 11/13/12.
//
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ReadViewController.h"
#import "Searchable.h"

@interface HomeViewController : UIViewController
<UICollectionViewDataSource,
UICollectionViewDelegate,
Searchable,
MainViewControllerDelegate,
ReadViewControllerDelegate>
- (id)initWithFrame: (CGRect) frame;
@end
