//
//  ViewController.h
//  BookApp
//
//  Created by Nalin on 11/1/12.
//
//

#import <UIKit/UIKit.h>
#import "ISColumnsController.h"

@interface ViewController : UIViewController <RKObjectLoaderDelegate>
@property int pageNumber;
@property (retain, nonatomic) ISColumnsController *columnsController;
@property (nonatomic, strong) UILabel *text;

@end
