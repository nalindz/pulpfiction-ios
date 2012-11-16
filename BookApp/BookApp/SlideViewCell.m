//
//  SlideViewCell.m
//  BookApp
//
//  Created by Nalin on 11/5/12.
//
//

#import "SlideViewCell.h"

@interface SlideViewCell()
@property (nonatomic, strong) UILabel *textLabel;
@end


@implementation SlideViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.numberOfLines = 0;
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void) prepareForReuse {
    self.transform = CGAffineTransformIdentity;
}


- (void) renderWithPage: (Page *) page {
    //self.textLabel.font = [UIFont fontWithName:@"Meta Serif OT" size:30];
    self.textLabel.font = [self.delegate fontForSlideViewCell];
    [self.textLabel positionCenterOf:self withMargin:[self.delegate pageMargin]];
    self.textLabel.text = page.text;
}

@end
