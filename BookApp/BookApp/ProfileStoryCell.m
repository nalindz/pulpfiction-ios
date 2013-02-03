//
//  ProfileStoryCell.m
//  BookApp
//
//  Created by Nalin on 2/2/13.
//
//

#import "ProfileStoryCell.h"

@interface ProfileStoryCell()
@property (nonatomic, strong) UIImageView *coverPhotoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *tagsTextField;
@end


#define coverPhotoSize 200
#define topPadding 20
#define bottomPadding 20
#define leftPadding 30;

@implementation ProfileStoryCell


- (UITextField *)tagsTextField {
    if (_tagsTextField == nil) {
        _tagsTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _tagsTextField.width = 500;
        _tagsTextField.height = 200;
        _tagsTextField.font = [UIFont fontWithName:@"MetaBoldLF-Roman" size:26];
        _tagsTextField.placeholder = @"enter #tags";
    }
    return _tagsTextField;
    
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont fontWithName:@"MetaBoldLF-Roman" size:30];
        _titleLabel.textColor = [UIColor darkGrayColor];
    }
    return _titleLabel;
}

- (UIImageView *)coverPhotoImageView {
    if (_coverPhotoImageView == nil) {
        _coverPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _coverPhotoImageView.width = coverPhotoSize;
        _coverPhotoImageView.height = coverPhotoSize;
        _coverPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverPhotoImageView.clipsToBounds = YES;
        _coverPhotoImageView.x = leftPadding;
        _coverPhotoImageView.y = topPadding;
    }
    return _coverPhotoImageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.coverPhotoImageView];
        [self.titleLabel putToRightOf:self.coverPhotoImageView withMargin:20];
        [self.tagsTextField putBelow:self.titleLabel withMargin:50];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Initialization code
    }
    return self;
}

+ (CGFloat)cellHeight {
    return coverPhotoSize + topPadding + bottomPadding;
}

- (void)renderWithStory: (Story *) story {
    [self.titleLabel autoSizeWithText:story.title];
    [self.coverPhotoImageView setImageWithURL:[NSURL URLWithString:story.cover_url]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
