//
//  MainVC.m
//  BookApp
//
//  Created by Nalin on 2/9/13.
//
//

#import "MainVC.h"
#import "UIButton+ResizeWithAspectRatio.h"

@interface MainVC ()
@property (nonatomic, strong) UITextField *searchBox;
@property (nonatomic, strong) UIButton *bookmarksButton;
@property (nonatomic, strong) UIButton *homeButton;
@property (nonatomic, strong) UILabel *homeLabel;
@property (nonatomic, strong) UILabel *bookmarksLabel;
@property (nonatomic, strong) UILabel *profileLabel;
@property (nonatomic, strong) UIButton *profileButton;

// state
@property (nonatomic, weak) UILabel *visibleButtonLabel;
//

@end

@interface tabLabel : UILabel
@end
@implementation tabLabel
- (id)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.font = [UIFont h5];
        self.textColor = [UIColor darkGrayColor];
        self.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
@end


@implementation MainVC
- (UILabel*) homeLabel {
    if (_homeLabel == nil) {
        _homeLabel = [[tabLabel alloc] init];
        [_homeLabel autoSizeWithText:@"home"];
    }
    return _homeLabel;
}

- (UILabel*) profileLabel {
    if (_profileLabel == nil) {
        _profileLabel = [[tabLabel alloc] init];
        [_profileLabel autoSizeWithText:@"profile"];
    }
    return _profileLabel;
}

- (UILabel*) bookmarksLabel {
    if (_bookmarksLabel == nil) {
        _bookmarksLabel = [[tabLabel alloc] init];
        [_bookmarksLabel autoSizeWithText:@"bookmarks"];
    }
    return _bookmarksLabel;
}

- (UITextField*) searchBox {
    if (_searchBox == nil) {
        _searchBox = [[UITextField alloc] initWithFrame:CGRectMake(40, 40, 100, 100)];
        _searchBox.width = self.view.width * 0.6;
        _searchBox.height = 50;
        _searchBox.font = [UIFont h2];
        _searchBox.returnKeyType = UIReturnKeySearch;
        _searchBox.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _searchBox.layer.borderWidth = 1.0;
    }
    return _searchBox;
}

- (UIButton*) homeButton {
    if (_homeButton == nil) {
        _homeButton = [UIButton initWithImageNamed:@"home-button"];
        [_homeButton resizeHeight:self.searchBox.height];
        [_homeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_homeButton addTarget:self action:@selector(homePressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _homeButton;
}

- (UIButton*) bookmarksButton {
    if (_bookmarksButton == nil) {
        _bookmarksButton = [UIButton initWithImageNamed:@"bookmark-button"];
        [_bookmarksButton resizeHeight:self.searchBox.height];
        [_bookmarksButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_bookmarksButton addTarget:self action:@selector(bookmarksPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bookmarksButton;
}

- (UIButton*) profileButton {
    if (_profileButton == nil) {
        _profileButton = [UIButton initWithImageNamed:@"profile-button"];
        [_profileButton resizeHeight:self.searchBox.height];
        [_profileButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_profileButton addTarget:self action:@selector(profilePressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _profileButton;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.searchBox putInRightEdgeOf:self.view withMargin:20];
    [self.homeButton positionLeftOf:self.searchBox withMargin:50];
    [self.bookmarksButton positionLeftOf:self.homeButton withMargin:50];
    [self.profileButton positionLeftOf:self.bookmarksButton withMargin:50];
    
}

@end
