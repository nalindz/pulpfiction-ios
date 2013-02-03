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
@property (nonatomic, strong) UITextView *tagsTextView;
@end


#define coverPhotoSize 200
#define topPadding 20
#define bottomPadding 20
#define leftPadding 30;

@implementation ProfileStoryCell


- (UITextView *)tagsTextView {
    if (_tagsTextView == nil) {
        _tagsTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _tagsTextView.width = 500;
        _tagsTextView.height = 200;
        _tagsTextView.font = [UIFont fontWithName:@"MetaBoldLF-Roman" size:26];
        //_tagsTextView.placeholder = @"enter #tags";
        _tagsTextView.delegate = self;
    }
    return _tagsTextView;
    
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
        [self.tagsTextView putBelow:self.titleLabel withMargin:50];
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


#pragma mark UITextViewDelegate


- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // allow backspace always
    NSError *error = NULL;
    if ([text isEqualToString:@""]) {
        return YES;
    }
    
    // only allow letters and hash to be inputed
    NSRegularExpression *alphaRegex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z# ]" options:NSRegularExpressionCaseInsensitive error:&error];
     if (![alphaRegex numberOfMatchesInString:text
                                                    options:0
                                       range:NSMakeRange(0, [text length])]) {
         return NO;
     }
    
    if ([[textView.text trim] hasSuffix:@"#"]) {
        if ([text isEqualToString:@"#"] || [text isEqualToString:@" "])
            return NO;
        else
            return YES;
    } else if ([text isEqualToString:@"#"]) {
        if (![textView.text hasSuffix:@" "] && textView.text.length != 0) {
            textView.text = [NSString stringWithFormat:@"%@ ", textView.text];
        }
        return YES;
    }
    if ([text isEqualToString:@" "]
        && (textView.text.length == 0 || [textView.text hasSuffix:@" "]))
        return  NO;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#" options:NSRegularExpressionCaseInsensitive error:&error];
   
    NSString *modifiedString = [regex stringByReplacingMatchesInString:textView.text options:0 range:NSMakeRange(0, textView.text.length) withTemplate:@""];
    NSLog(@"modified string: %@", modifiedString);
    
    NSArray *tags = [modifiedString componentsSeparatedByString:@" "];
    NSMutableArray *newTags = [NSMutableArray array];
    for (NSString *tag in tags) {
        [newTags addObject:[NSString stringWithFormat:@"#%@", tag]];
    }
    
    NSString *newString = [newTags componentsJoinedByString:@" "];
    
    textView.text = newString;
    return YES;
}

@end
