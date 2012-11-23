
//  SlideViewCell.m
//  BookApp
//
//  Created by Nalin on 11/5/12.
//
//

#import "SlideViewCell.h"
#import "UIButton+AutoSizeWithImage.h"

@interface SlideViewCell()
@property (nonatomic, strong) UIView *titleBar;
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation SlideViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.numberOfLines = 0;
        [self addSubview:self.textLabel];
        
        self.titleBar = [[UIView alloc] init];
        self.titleBar.width = self.width;
        self.titleBar.height = 40;
        
        self.backButton = [[UIButton alloc] init];
        [self.backButton autoSizeWithImage:@"close-button"];
        self.backButton.x = self.width - self.backButton.width - 20;
        [self.backButton addTarget:self.delegate action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:self.backButton];
        self.backButton.y = 20;
    }
    return self;
}

- (void) prepareForReuse {
    self.transform = CGAffineTransformIdentity;
}


- (void) renderWithPage: (Page *) page {
    self.textLabel.font = [self.delegate fontForSlideViewCell];
    [self.textLabel positionCenterOf:self withMargin:[self.delegate pageMargin]];
    self.textLabel.text = page.text;
    //self.backButton.x = [self.delegate pageMargin];
}

@end
