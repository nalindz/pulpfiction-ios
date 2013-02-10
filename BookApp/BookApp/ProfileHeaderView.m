//
//  ProfileView.m
//  BookApp
//
//  Created by Nalin on 2/2/13.
//
//

#import "ProfileHeaderView.h"

@interface ProfileHeaderView()
@property (nonatomic, strong) UILabel *usernameLabel;
@end

@implementation ProfileHeaderView

- (UILabel *) usernameLabel {
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _usernameLabel.font = [UIFont h1];
        _usernameLabel.x = 30;
        _usernameLabel.y = 5;
    }
    return _usernameLabel;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.usernameLabel];
    }
    return self;
}

- (void)setUsername: (NSString *) username {
    [self.usernameLabel autoSizeWithText:username];
}

@end
