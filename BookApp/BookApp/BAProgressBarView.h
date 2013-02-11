//
//  BAProgressBarView.h
//  BookApp
//
//  Created by Nalin on 12/6/12.
//
//

#import <UIKit/UIKit.h>

@protocol BAProgressBarViewDelegate
- (void) scrollToPercentage: (CGFloat) percentage;
@end

@interface BAProgressBarView : UIView
- (void) setPercentage: (CGFloat) percentage;
@property (nonatomic, weak) id<BAProgressBarViewDelegate> delegate;
@end
