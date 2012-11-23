//
//  SlideViewCell.h
//  BookApp
//
//  Created by Nalin on 11/5/12.
//
//

#import <UIKit/UIKit.h>
#import "Page.h"

@protocol SlideViewCellDelegate
- (UIFont *) fontForSlideViewCell;
- (int) pageMargin;
@end

@interface SlideViewCell : UIView
- (void) prepareForReuse;
- (void) renderWithPage: (Page *) page;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) id<SlideViewCellDelegate> delegate;
@end


