//
//  SelectUsernameView.h
//  BookApp
//
//  Created by Nalin on 2/27/13.
//
//

#import <UIKit/UIKit.h>
@protocol SelectUsernameViewDelegate
- (void)userNameSelected: (NSString *)username;
@end

@interface SelectUsernameView : UIView
<UITextFieldDelegate>
@property (nonatomic, weak) id<SelectUsernameViewDelegate> delegate;
- (void)setSuggestedUsername: (NSString *) text;
- (void)showTooShortError;
- (void)showTooLongError;
- (void)showAlreadyTakenError;
- (void)showInvalidCharactersError;
@end
