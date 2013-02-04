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
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation ProfileHeaderView

- (UILabel *) usernameLabel {
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _usernameLabel.font = [UIFont h1];
        _usernameLabel.x = 30;
        _usernameLabel.y = 20;
    }
    return _usernameLabel;
}

- (UIButton*) backButton {
    if (_backButton == nil) {
        _backButton = [UIButton initWithImageNamed:@"close-button"];
        _backButton.adjustsImageWhenHighlighted = NO;
        [_backButton addTarget:self.delegate action:@selector(backClicked)forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.usernameLabel];
        [self.backButton putInRightEdgeOf:self withMargin:20];
    }
    return self;
}


- (void)setUsername: (NSString *) username {
    [self.usernameLabel autoSizeWithText:username];
    self.backButton.y = self.usernameLabel.y;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
