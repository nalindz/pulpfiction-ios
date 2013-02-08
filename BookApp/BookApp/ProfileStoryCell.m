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
        _tagsTextView.font = [UIFont h2];
        //_tagsTextView.placeholder = @"enter #tags";
        _tagsTextView.delegate = self;
    }
    return _tagsTextView;
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.delegate.firstResponder isFirstResponder] && [touch view] != self.delegate.firstResponder) {
        [self.delegate.firstResponder resignFirstResponder];
        self.delegate.firstResponder = nil;
    }
    [super touchesBegan:touches withEvent:event];
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
    self.story = story;
    [self.titleLabel autoSizeWithText:story.title];
    [self.coverPhotoImageView setImageWithURL:[NSURL URLWithString:story.cover_url]];
    self.tagsTextView.text = story.tags;
}

- (NSArray *) tagsFromText: (NSString *) text {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
    NSLog(@"modified string: %@", modifiedString);
    
    return [modifiedString componentsSeparatedByString:@" "];
}

- (void) postTags:(NSString *)tagsString {
    self.story.tags = tagsString;
    [[RKObjectManager sharedManager]  putObject:self.story usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObject = ^(id object){
            NSLog(@"Tags Posted : %@", object);
        };
        
        loader.onDidFailLoadWithError = ^(NSError *error) {
            NSLog(@"Error updating tags: %@", error);
        };
    }];
}


- (NSString *)tagsStringFromTags:(NSArray *)tags {
    NSMutableArray *newTags = [NSMutableArray array];
    for (NSString *tag in tags) {
        [newTags addObject:[NSString stringWithFormat:@"#%@", tag]];
    }
   return [newTags componentsJoinedByString:@" "];
}


#pragma mark UITextViewDelegate

- (void) textViewDidEndEditing:(UITextView *)textView {
    [self postTags:textView.text];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.delegate performSelector:@selector(setFirstResponder:) withObject:self.tagsTextView];
}


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
    
    NSArray *tags = [self tagsFromText:textView.text];
    textView.text = [self tagsStringFromTags:tags];
    return YES;
}

@end
