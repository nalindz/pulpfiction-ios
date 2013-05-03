//
//  MainViewController.m
//  BookApp
//
//  Created by Nalin on 2/9/13.
//
//

#import "MainViewController.h"
#import "UIButton+ResizeWithAspectRatio.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "UIView+BounceAnimate.h"
#import "Searchable.h"
#import "PaddedUITextField.h"

@interface MainViewController ()

@property (nonatomic, strong) HomeViewController* homeViewController;
@property (nonatomic, strong) ProfileViewController* profileViewController;
@property (nonatomic, weak)  UIViewController <Searchable, MainViewControllerDelegate> *activeViewController;
@property (nonatomic, strong) PaddedUITextField *searchBox;
@property (nonatomic, strong) UIImageView *searchIcon;
@property (nonatomic, strong) UIButton *bookmarksButton;
@property (nonatomic, strong) UIButton *homeButton;
@property (nonatomic, strong) UILabel *homeLabel;
@property (nonatomic, strong) UILabel *bookmarksLabel;
@property (nonatomic, strong) UILabel *profileLabel;
@property (nonatomic, strong) UIButton *profileButton;

// state
@property (nonatomic, weak) UILabel *visibleButtonLabel;

@end

#define headerHeight 100

@interface tabLabel : UILabel
@end
@implementation tabLabel
- (id)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.font = [UIFont h6];
        self.textColor = [UIColor darkGrayColor];
        self.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
@end


@implementation MainViewController
- (UILabel*)homeLabel {
    if (_homeLabel == nil) {
        _homeLabel = [[tabLabel alloc] init];
        [_homeLabel autoSizeWithText:@"home"];
    }
    return _homeLabel;
}

- (UILabel*)profileLabel {
    if (_profileLabel == nil) {
        _profileLabel = [[tabLabel alloc] init];
        [_profileLabel autoSizeWithText:@"profile"];
    }
    return _profileLabel;
}

- (UILabel*)bookmarksLabel {
    if (_bookmarksLabel == nil) {
        _bookmarksLabel = [[tabLabel alloc] init];
        [_bookmarksLabel autoSizeWithText:@"bookmarks"];
    }
    return _bookmarksLabel;
}

- (UIImageView *)searchIcon {
    if (_searchIcon == nil) {
        _searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
        UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(search)];
        [_searchIcon addGestureRecognizer:recognizer];
        _searchIcon.userInteractionEnabled = YES;
    }
    return _searchIcon;
}

- (PaddedUITextField *)searchBox {
    if (_searchBox == nil) {
        _searchBox = [[PaddedUITextField alloc] initWithFrame:CGRectZero];
        _searchBox.topPadding = 5;
        _searchBox.rightPadding = self.searchIcon.width + 20;
        _searchBox.leftPadding = 10;
        _searchBox.width = self.view.width * 0.6;
        _searchBox.y = 20;
        _searchBox.height = 50;
        _searchBox.font = [UIFont h2];
        _searchBox.layer.cornerRadius = 5.0;
        _searchBox.layer.masksToBounds = YES;
        _searchBox.returnKeyType = UIReturnKeySearch;
        _searchBox.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _searchBox.layer.borderWidth = 1.0;
        [self.searchIcon putInRightEdgeOf:_searchBox withMargin:10];
        self.searchIcon.centerY = _searchBox.height / 2;
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


- (void)setActiveViewController:(UIViewController <Searchable, MainViewControllerDelegate>*)activeViewController {
    if (activeViewController == _activeViewController) return;
    [_activeViewController.view removeFromSuperview];
    [self.view addSubview:activeViewController.view];
    _activeViewController = activeViewController;
}

- (HomeViewController*) homeViewController {
    if (_homeViewController == nil) {
        _homeViewController = [[HomeViewController alloc] initWithFrame:CGRectMake(0, headerHeight, self.view.width, self.view.height - headerHeight)];
        [self addChildViewController:_homeViewController];
    }
    return _homeViewController;
}

- (ProfileViewController*) profileViewController {
    if (_profileViewController == nil) {
        _profileViewController = [[ProfileViewController alloc] init];
        _profileViewController.view.frame = CGRectMake(0, headerHeight, self.view.width, self.view.height);
        [self addChildViewController:_profileViewController];
    }
    return _profileViewController;
}

- (void) textFieldFinished: (UITextField *) textField {
    [self.activeViewController search:textField.text];
}

- (void)search {
    [self.activeViewController search:self.searchBox.text];
}

- (void) showLabelForButton: (UIButton *)button {
    UILabel *animatingLabel;
    if (button == self.bookmarksButton) {
        animatingLabel = self.bookmarksLabel;
    } else if (button == self.homeButton) {
        animatingLabel = self.homeLabel;
    } else if (button == self.profileButton) {
        animatingLabel = self.profileLabel;
    }
    
    if (animatingLabel == self.visibleButtonLabel) return;
    
    [self.visibleButtonLabel hideAnimateWithDuration:0.1 offset:20];
    [animatingLabel bounceAnimateWithDuration:0.1 offset:10 bounces:1];
    self.visibleButtonLabel = animatingLabel;
}

- (void)homePressed {
    [self showLabelForButton:self.homeButton];
    self.searchBox.text = @"";
    if (self.activeViewController == self.homeViewController) {
        //[self.homeViewController search:self.searchBox.text];
    }
    self.activeViewController = self.homeViewController;
    [self.activeViewController performSelector:@selector(homePressed)];
}

- (void)bookmarksPressed {
    [self showLabelForButton:self.bookmarksButton];
    self.activeViewController = self.homeViewController;
    self.searchBox.text = @"";
    [self.activeViewController performSelector:@selector(bookmarksPressed)];
}

- (void)profilePressed {
    [self showLabelForButton:self.profileButton];
    self.activeViewController = self.profileViewController;
    [self.activeViewController viewWillAppear:NO];
    self.searchBox.text = @"";
    [self.activeViewController tabButtonPressed];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.searchBox putInRightEdgeOf:self.view withMargin:20];
    
    
    [self setupTabLabels];
    
    [self.searchBox addTarget:self
                  action:@selector(textFieldFinished:)
                  forControlEvents:UIControlEventEditingDidEndOnExit];
    self.activeViewController = self.homeViewController;
    [self homePressed];
}

- (void)viewWillAppear:(BOOL)animated {
    //[self homePressed];
}

- (void) setupTabLabels {
    [self.homeButton positionLeftOf:self.searchBox withMargin:50];
    [self.homeLabel putBelow:self.homeButton withMargin:7];
    self.homeLabel.center = CGPointMake(self.homeButton.center.x, self.homeLabel.center.y);
    self.homeLabel.x = self.homeLabel.x + 2;
    
    [self.bookmarksLabel putBelow:self.bookmarksButton withMargin:5];
    [self.bookmarksButton positionLeftOf:self.homeButton withMargin:50];
    
    [self.bookmarksLabel putBelow:self.bookmarksButton withMargin:5];
    self.bookmarksLabel.center = CGPointMake(self.bookmarksButton.center.x, self.bookmarksLabel.center.y);
    self.bookmarksLabel.x = self.bookmarksLabel.x + 2;
    
    
    [self.profileButton positionLeftOf:self.bookmarksButton withMargin:50];
    [self.profileLabel putBelow:self.profileButton withMargin:5];
    self.profileLabel.center = CGPointMake(self.profileButton.center.x, self.profileLabel.center.y);
}

@end
