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
@property (nonatomic, weak) id<SelectUsernameViewDelegate> delegate;
- (void) setSuggestedUsername: (NSString *) text;
@end