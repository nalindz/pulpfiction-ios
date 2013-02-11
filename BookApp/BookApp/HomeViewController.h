//
//  DiscoverVC.h
//  BookApp
//
//  Created by Nalin on 11/13/12.
//
//

#import <UIKit/UIKit.h>
#import "Searchable.h"

@interface HomeViewController : UIViewController
<UICollectionViewDataSource,
RKObjectLoaderDelegate,
UICollectionViewDelegate,
Searchable>

@end
