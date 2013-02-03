//
//  StoryCell.m
//  BookApp
//
//  Created by Nalin on 11/13/12.
//
//

#import "StoryCell.h"

@interface StoryCell()
@property (nonatomic, strong) UIView *centeredView;
@property (nonatomic, strong) UIView *blackOverlay;
@property (nonatomic, strong) UIImageView *coverImageView;
@end

@implementation StoryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.centeredView = [[UIView alloc] init];
        [self.centeredView putInCenterOf:self withMargin:20];
        self.centeredView.backgroundColor = [UIColor colorWithRed:0.24 green:0.25 blue:0.24 alpha:1.0];
        self.coverImageView = [[UIImageView alloc] initWithFrame:self.centeredView.frame];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        self.blackOverlay = [[UIView alloc] initWithFrame:self.centeredView.frame];
        self.blackOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        [self addSubview:self.coverImageView];
        [self addSubview:self.blackOverlay];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.width = self.centeredView.width;
        [self.titleLabel setHeight:50];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont fontWithName:@"MetaBoldLF-Roman" size:30];
        //self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self.centeredView addSubview:self.titleLabel];
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLabel.numberOfLines = 0;
        
    }
    return self;
}

- (void)renderWithStory: (Story *)story indexPath: (NSIndexPath *) indexPath {
    [self.titleLabel setText:story.title fixedWidth:YES];
    [self.titleLabel stickToBottomOf:self.blackOverlay];
    NSLog(@"THe URL: %@", story.cover_url);
    [self.coverImageView setImageWithURL:[NSURL URLWithString:story.cover_url]];
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
