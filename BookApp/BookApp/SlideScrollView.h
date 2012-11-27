//
//  SlideScrollView.h
//  BookApp
//
//  Created by Nalin on 11/6/12.
//
//

#import <UIKit/UIKit.h>
#import "SlideViewCell.h"
#import "Page.h"

@protocol SlideScrollDataSource

- (NSInteger)numberOfPages;
- (SlideViewCell *) viewAtIndex: (NSInteger) index;
    
@end

@interface SlideScrollView : UIScrollView
@property (nonatomic, assign) id <SlideScrollDataSource> dataSource;
- (void)reloadData;
- (void)loadNewData;
- (void)reloadPage: (Page *)page;

- (void) softReset;
@end


