//
//  ViewController.h
//  BookApp
//
//  Created by Nalin on 11/1/12.
//
//

#import <UIKit/UIKit.h>
#import "ReadViewController.h"

@interface ViewController : UIViewController <RKObjectLoaderDelegate>
@property int pageNumber;
@property (retain, nonatomic) ReadViewController *columnsController;
@property (nonatomic, strong) UILabel *text;

@end
