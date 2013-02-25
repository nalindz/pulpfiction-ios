//
//  FeedBlankSlateView.m
//  BookApp
//
//  Created by Nalin on 2/24/13.
//
//

#import "BookmarksBlankSlateView.h"

@implementation BookmarksBlankSlateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *blankSlateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmarks_blank_slate"]];
        [self addSubview:blankSlateImageView];
        self.frame = blankSlateImageView.frame;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
