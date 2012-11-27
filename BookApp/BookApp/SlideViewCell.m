
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
}


- (void)renderWithPageNumber: (NSNumber *) pageNumber storyId: (NSNumber *) storyId {
    CGAffineTransform currentTransform = self.transform;
    self.transform = CGAffineTransformIdentity;
    self.storyId = storyId;
    self.pageNumber = pageNumber;
    Page *page = [Page findFirstWithPredicate:[NSPredicate predicateWithFormat:@"page_number == %@ AND story_id == %@", self.pageNumber, self.storyId]];
    self.textLabel.font = [self.delegate fontForSlideViewCell];
    [self.textLabel positionCenterOf:self withMargin:[self.delegate pageMargin]];
    self.textLabel.text = page.text;
    //self.backButton.x = [self.delegate pageMargin];
    self.transform = currentTransform;
}

-  (void)reRender {
    //Page *page = [Page findFirstWithPredicate:[NSPredicate predicateWithFormat:@"page_number == %@ AND story_id == %@", self.pageNumber, self.storyId]];
    //NSLog(@"The NEW PAGE MEOWZILLA: %@", page);
    CGAffineTransform currentTransform = self.transform;
    self.transform = CGAffineTransformIdentity;
    [self renderWithPageNumber:self.pageNumber storyId:self.storyId];
    self.transform = currentTransform;
}


@end
