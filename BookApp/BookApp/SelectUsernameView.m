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
- (UIButton*) nextButton {
    if (_nextButton == nil) {
        _nextButton = [UIButton initWithImageNamed:@"username-next-button"];
        [_nextButton addTarget:self action:@selector(clickedNext) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.centerX = self.center.x;
    }
    return _nextButton;
}

- (UITextField*) usernameTextField {
    if (_usernameTextField == nil) {
        _usernameTextField = [[PaddedUITextField alloc] initWithFrame:CGRectZero];
        _usernameTextField.topPadding = 5;
        _usernameTextField.textAlignment = NSTextAlignmentCenter;
        _usernameTextField.width = self.selectAUsernameLabel.width + 50;
        _usernameTextField.font = [UIFont h2];
        _usernameTextField.height = 50;
        _usernameTextField.centerX = self.center.x;
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
        [self.nextButton putBelow:self.usernameTextField withMargin:40];
    }
    return self;
}


- (void) setSuggestedUsername: (NSString *) text {
    self.usernameTextField.text = text;
}

- (void)clickedNext {
    [self.delegate userNameSelected:self.usernameTextField.text];
}

@end
