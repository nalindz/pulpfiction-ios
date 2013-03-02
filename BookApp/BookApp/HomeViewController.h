//
//  DiscoverVC.h
//  BookApp
//
//  Created by Nalin on 11/13/12.
//
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "Searchable.h"

@interface HomeViewController : UIViewController
<UICollectionViewDataSource,
RKObjectLoaderDelegate,
UICollectionViewDelegate,
Searchable,
MainViewControllerDelegate>
- (id)initWithFrame: (CGRect) frame;
@end
