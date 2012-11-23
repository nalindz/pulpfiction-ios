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
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) id<SlideViewCellDelegate> delegate;

- (void)prepareForReuse;
- (void)renderWithPageNumber: (NSNumber *) pageNumber storyId: (NSNumber *) storyId;
- (void)reRender;
@end


