//
//  UIButton+AutoSizeWithImage.h
//  BookApp
//
//  Created by Nalin on 11/18/12.
//
//

#import <UIKit/UIKit.h>

@interface UIButton (AutoSize)

- (void)autoSizeWithImage: (NSString *) imageName;
- (void) autoSizeWithText: (NSString *) text fixedWidth: (BOOL) fixedWidth;
@end
