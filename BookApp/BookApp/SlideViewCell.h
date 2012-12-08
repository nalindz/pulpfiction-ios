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
- (void) fontIncrease;
- (void) fontDecrease;
- (void) hideAllControls;
- (void) showAllControls;
@end

@interface SlideViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) id<SlideViewCellDelegate> delegate;

- (void) hideControls;
- (void) showControls;
    - (void)prepareForReuse;
- (void)renderWithPageNumber: (NSNumber *) pageNumber
                     storyId: (NSNumber *) storyId
                        font: (UIFont *) font
                      margin: (CGFloat) margin
                showControls: (BOOL) showControls;
@end


