//
//  SelectUsernameView.m
//  BookApp
//
//  Created by Nalin on 2/27/13.
//
//

#import "SelectUsernameView.h"
#import "PaddedUITextField.h"

@interface SelectUsernameView()
@property (nonatomic, strong) UILabel* selectAUsernameLabel;
@property (nonatomic, strong) PaddedUITextField *usernameTextField;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *errorLabel;
@end
@implementation SelectUsernameView


- (UILabel*) selectAUsernameLabel {
    if (_selectAUsernameLabel == nil) {
        _selectAUsernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _selectAUsernameLabel.font = [UIFont h1];
        _selectAUsernameLabel.textColor = [UIColor darkGrayColor];
        [_selectAUsernameLabel autoSizeWithText:@"Pick a username!"];
        _selectAUsernameLabel.centerX = self.center.x;
        _selectAUsernameLabel.y = self.height * 1/3;
    }
    return _selectAUsernameLabel;
}

- (UILabel*) errorLabel {
    if (_errorLabel == nil) {
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _errorLabel.font = [UIFont h4];
        _errorLabel.textColor = [UIColor redColor];
    }
    return _errorLabel;
}
- (UIButton*) nextButton {
    if (_nextButton == nil) {
        _nextButton = [UIButton initWithImageNamed:@"username-next-button"];
        [_nextButton addTarget:self action:@selector(clickedNext) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UITextField*) usernameTextField {
    if (_usernameTextField == nil) {
        _usernameTextField = [[PaddedUITextField alloc] initWithFrame:CGRectZero];
        _usernameTextField.topPadding = 5;
        _usernameTextField.delegate = self;
        _usernameTextField.textAlignment = NSTextAlignmentCenter;
        _usernameTextField.width = self.selectAUsernameLabel.width + 50;
        _usernameTextField.font = [UIFont h2];
        _usernameTextField.height = 50;
        _usernameTextField.returnKeyType = UIReturnKeySearch;
        _usernameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _usernameTextField.layer.borderWidth = 1.0;
        _usernameTextField.layer.masksToBounds = YES;
        _usernameTextField.layer.cornerRadius = 5.0;
    }
    return _usernameTextField;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.selectAUsernameLabel];
        [self.usernameTextField putBelow:self.selectAUsernameLabel withMargin:10];
        _usernameTextField.centerX = self.center.x;
        [self.nextButton putBelow:self.usernameTextField withMargin:150];
        _nextButton.centerX = self.center.x;
    }
    return self;
}


- (void) setSuggestedUsername: (NSString *) text {
    self.usernameTextField.text = text;
}

- (void)clickedNext {
    [self.delegate userNameSelected:self.usernameTextField.text];
}

- (void)showTooShortError {
    [self.errorLabel autoSizeWithText:@"Your username is too short. Try something between 3-15 characters"];
    [self.errorLabel putBelow:self.usernameTextField withMargin:10];
}

@end
