//
//  SlideViewCell.h
//  BookApp
//
//  Created by Nalin on 11/5/12.
//
//

#import <UIKit/UIKit.h>
#import "Page.h"
#import "BAProgressBarView.h"

@protocol PageCellDelegate
@optional
- (UIFont *)fontForPageCell;
- (int)pageMargin;
- (void)fontIncrease;
- (void)fontDecrease;
- (void)hideAllControls;
- (void)showAllControls;
- (void)bookmarkClicked;
- (CGRect)progressBarFrameForPageCell;
- (void)scrollToPercentage: (CGFloat) percentage;
@end

@interface PageCell : UICollectionViewCell <BAProgressBarViewDelegate>
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, weak) id<PageCellDelegate> delegate;

- (void)setPercentage: (CGFloat) percentage;
- (void)hideControls;
- (void)showControls;
- (void)prepareForReuse;
- (void)setPageBookmarked;
- (void)setPageUnbookmarked;
- (void)renderWithPageNumber: (NSNumber *) pageNumber
                     storyId: (NSNumber *) storyId
                        font: (UIFont *) font
                      margin: (CGFloat) margin
                    progress: (CGFloat) progress
                showControls: (BOOL) showControls;
    
@end


