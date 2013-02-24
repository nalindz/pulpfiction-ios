//
//  StoryCell.m
//  BookApp
//
//  Created by Nalin on 11/13/12.
//
//

#import "StoryCell.h"
#import "User.h"

@interface StoryCell()
@property (nonatomic, strong) UIView *centeredView;
@property (nonatomic, strong) UIView *blackOverlay;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tagsLabel;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIImageView *viewCountImageView;
@property (nonatomic, strong) UILabel *viewCountLabel;
@property (nonatomic, strong) UIImageView *bookmarkCountImageView;
@property (nonatomic, strong) UILabel *bookmarkCountLabel;
@end

@implementation StoryCell

- (UILabel*) viewCountLabel {
    if (_viewCountLabel == nil) {
        _viewCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _viewCountLabel.numberOfLines = 0;
        _viewCountLabel.backgroundColor = [UIColor clearColor];
        _viewCountLabel.font = [UIFont h5];
        _viewCountLabel.textColor = [UIColor whiteColor];
    }
    return _viewCountLabel;
}

- (UIImageView*) viewCountImageView {
    if (_viewCountImageView == nil) {
        _viewCountImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"view_count"]];
        _viewCountImageView.x = 10;
    }
    return _viewCountImageView;
}

- (UILabel*) titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.width = self.centeredView.width - 15;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont h3];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 0;
        _titleLabel.x = 10;
    }
    return _titleLabel;
}

- (UILabel*) tagsLabel {
    if (_tagsLabel == nil) {
        _tagsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tagsLabel.width = self.centeredView.width - 15;
        _tagsLabel.backgroundColor = [UIColor clearColor];
        _tagsLabel.textColor = [UIColor whiteColor];
        _tagsLabel.font = [UIFont h6];
        _tagsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _tagsLabel.numberOfLines = 0;
        _tagsLabel.x = 10;
    }
    return _tagsLabel;
}

- (UILabel*)usernameLabel {
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _usernameLabel.width = self.centeredView.width - 15;
        _usernameLabel.backgroundColor = [UIColor clearColor];
        _usernameLabel.textColor = [UIColor whiteColor];
        _usernameLabel.font = [UIFont h4];
        _usernameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _usernameLabel.numberOfLines = 0;
        _usernameLabel.x = 10;
    }
    return _usernameLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.centeredView = [[UIView alloc] initWithFrame:self.bounds];
        [self.centeredView putInCenterOf:self withMargin:2];
        self.centeredView.backgroundColor = [UIColor colorWithRed:0.24 green:0.25 blue:0.24 alpha:1.0];
        self.coverImageView = [[UIImageView alloc] initWithFrame:self.centeredView.frame];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        self.blackOverlay = [[UIView alloc] initWithFrame:self.centeredView.frame];
        self.blackOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [self addSubview:self.coverImageView];
        [self addSubview:self.blackOverlay];
        [self.blackOverlay addSubview:self.usernameLabel];
        [self.titleLabel putInTopOf:self.blackOverlay withMargin:10];
    }
    return self;
}

- (void)renderWithStory: (Story *)story indexPath: (NSIndexPath *) indexPath {
    [self.titleLabel setText:story.title fixedWidth:YES];
    [self.tagsLabel setText:story.tags fixedWidth:YES];
    [self.tagsLabel putInBottomOf:self.blackOverlay withMargin:5];
    [self.coverImageView setImageWithURL:[NSURL URLWithString:story.cover_url]];
    
    [self.usernameLabel setText:[NSString stringWithFormat:@"@%@", story.user.username] fixedWidth:YES];
    [self.usernameLabel positionAbove:self.tagsLabel withMargin:1];
    [self.blackOverlay addSubview:self.viewCountImageView];
    [self.viewCountImageView putBelow:self.titleLabel withMargin:3];
    [self.viewCountLabel autoSizeWithText:[NSString stringWithFormat:@"%@", story.views_count]];
    [self.viewCountLabel putToRightOf:self.viewCountImageView withMargin:3];
    self.viewCountLabel.y = self.viewCountLabel.y - 2;
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
