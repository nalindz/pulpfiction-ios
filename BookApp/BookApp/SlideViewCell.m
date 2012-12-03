
//  SlideViewCell.m
//  BookApp
//
//  Created by Nalin on 11/5/12.
//
//

#import "SlideViewCell.h"

@interface SlideViewCell()
@property (nonatomic, strong) UIView *titleBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) NSNumber *pageNumber;
@property (nonatomic, strong) NSNumber *storyId;

@end

@implementation SlideViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.numberOfLines = 0;
        [self addSubview:self.textLabel];
        
        self.titleBar = [[UIView alloc] init];
        self.titleBar.width = self.width;
        self.titleBar.height = 40;
        
        self.backButton = [[UIButton alloc] init];
        [self.backButton autoSizeWithImage:@"close-button"];
        self.backButton.x = self.width - self.backButton.width - 20;
        [self.backButton addTarget:self.delegate action:@selector(fontIncrease) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:self.backButton];
        self.backButton.y = 20;
    }
    return self;
}

- (void)prepareForReuse {
    self.transform = CGAffineTransformIdentity;
    self.textLabel.text = @"";
}


- (void)renderWithPageNumber: (NSNumber *) pageNumber
                     storyId: (NSNumber *) storyId
                        font: (UIFont *) font
                      margin: (CGFloat) margin {
    CGAffineTransform currentTransform = self.transform;
    self.transform = CGAffineTransformIdentity;
    self.storyId = storyId;
    self.pageNumber = pageNumber;
    Page *page = [Page findFirstWithPredicate:[NSPredicate predicateWithFormat:@"page_number == %@ AND story_id == %@", self.pageNumber, self.storyId]];
    self.textLabel.font = font;
    [self.textLabel positionCenterOf:self withMargin:margin];
    self.textLabel.text = page.text;
    //self.backButton.x = [self.delegate pageMargin];
    self.transform = currentTransform;
}


@end
