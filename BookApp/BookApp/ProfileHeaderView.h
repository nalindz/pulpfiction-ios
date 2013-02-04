//
//  ProfileView.h
//  BookApp
//
//  Created by Nalin on 2/2/13.
//
//

#import <UIKit/UIKit.h>

@interface ProfileHeaderView : UIView
@property (nonatomic, weak) id delegate;
- (void)setUsername: (NSString *) username;
@end
