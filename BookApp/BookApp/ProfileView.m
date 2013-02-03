//
//  ProfileView.m
//  BookApp
//
//  Created by Nalin on 2/2/13.
//
//

#import "ProfileView.h"

@interface ProfileView()
@property (nonatomic, strong) UILabel *usernameLabel;
@end

@implementation ProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.usernameLabel];
    }
    return self;
}


- (void)setUsername: (NSString *) username {
    [self.usernameLabel autoSizeWithText:username];
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
