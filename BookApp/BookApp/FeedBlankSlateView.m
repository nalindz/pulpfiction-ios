//
//  FeedBlankSlateView.m
//  BookApp
//
//  Created by Nalin on 3/22/13.
//
//

#import "FeedBlankSlateView.h"

@interface FeedBlankSlateView()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation FeedBlankSlateView

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no-search-results"]];
    }
    return _imageView;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.font = [UIFont h2];
        _label.textColor = [UIColor darkGrayColor];
        _label.numberOfLines = 0;
        [_label autoSizeWithText:@"We couldn't find any stories.\nPlease try a different search"];
    }
    return _label;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.label];
        self.label.center = CGPointMake(self.width / 2, self.height / 3);
        [self.imageView putBelow:self.label withMargin:30];
        self.imageView.centerX = self.width / 2;
    }
    return self;
}

@end
