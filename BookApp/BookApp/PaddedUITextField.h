//
//  PaddedUITextField.h
//  BookApp
//
//  Created by Nalin on 4/24/12.
//

#import <UIKit/UIKit.h>

@interface PaddedUITextField : UITextField
@property (nonatomic, assign) float topPadding;
@property (nonatomic, assign) float bottomPadding;
@property (nonatomic, assign) float leftPadding;
@property (nonatomic, assign) float rightPadding;

@end
