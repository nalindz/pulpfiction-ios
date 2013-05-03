//
//  ProfileView.m
//  BookApp
//
//  Created by Nalin on 2/2/13.
//
//

#import "ProfileHeaderView.h"
#import "UserStat.h"

@interface ProfileHeaderView()
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *viewsLabel;
@property (nonatomic, strong) UILabel *bookmarksLabel;
@property (nonatomic, strong) UIImageView *bookmarksImageView;
@property (nonatomic, strong) UIImageView *viewsImageView;
@end

@implementation ProfileHeaderView

- (UILabel *) usernameLabel {
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _usernameLabel.font = [UIFont h1];
        _usernameLabel.x = 30;
        _usernameLabel.centerY = self.height / 2;
    }
    return _usernameLabel;
}

- (UILabel *)bookmarksLabel {
    if (_bookmarksLabel == nil) {
        _bookmarksLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bookmarksLabel.font = [UIFont h3];
    }
    return _bookmarksLabel;
}

- (UILabel *)viewsLabel {
    if (_viewsLabel == nil) {
        _viewsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _viewsLabel.font = [UIFont h3];
    }
    return _viewsLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.usernameLabel];
        self.bookmarksImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-bookmark"]];
        self.viewsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-view"]];
    }
    return self;
}

- (void)render {
    [self.bookmarksLabel autoSizeWithText:[API.sharedInstance.loggedInUser.stat.total_stories_bookmarks toString]];
    [self.bookmarksLabel putInRightEdgeOf:self withMargin:10];
    [self.bookmarksImageView putToLeftOf:self.bookmarksLabel withMargin:5];
    [self.usernameLabel autoSizeWithText:API.sharedInstance.loggedInUser.username];
    [self.bookmarksLabel autoSizeWithText:[API.sharedInstance.loggedInUser.stat.total_stories_bookmarks toString]];
    [self.viewsLabel autoSizeWithText:[API.sharedInstance.loggedInUser.stat.total_stories_views toString]];
    [self.viewsLabel putToLeftOf:self.bookmarksImageView withMargin:15];
    [self.viewsImageView putToLeftOf:self.viewsLabel withMargin:5];
    for (UIView *view in self.subviews)
        view.centerY = self.height / 2;
}


@end
