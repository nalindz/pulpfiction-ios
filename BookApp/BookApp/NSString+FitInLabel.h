//
//  NSString+FitInLabel.h
//  BookApp
//
//  Created by Nalin on 11/10/12.
//
//

#import <Foundation/Foundation.h>

@interface NSString (FitInLabel)
- (int)getSplitIndexWithFrame:(CGRect) frame andFont:(UIFont *)font;
@end
