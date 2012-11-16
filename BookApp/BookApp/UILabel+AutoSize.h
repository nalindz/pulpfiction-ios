//
//  UILabel+AutoSize.h
//  BookApp
//
//  Created by Nalin on 11/15/12.
//
//

#import <UIKit/UIKit.h>

@interface UILabel (AutoSize)
- (void) setText: (NSString *) text fixedWidth: (BOOL) fixedWidth;
@end
