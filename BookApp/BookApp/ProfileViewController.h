//
//  ProfileViewController.h
//  BookApp
//
//  Created by Haochen Li on 2012-11-26.
//
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate,
RKObjectLoaderDelegate>

@property (nonatomic, weak) id firstResponder;

@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *logoutBtn;
@property (strong, nonatomic) UILabel *baId;
@property (strong, nonatomic) UILabel *firstName;
@property (strong, nonatomic) UILabel *lastName;
@property (strong, nonatomic) UILabel *email;
@property (strong, nonatomic) UILabel *facebookId;
@end
