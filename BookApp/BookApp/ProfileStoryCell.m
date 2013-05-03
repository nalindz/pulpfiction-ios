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
@property (nonatomic, strong) UITextView *titleTextView;
@property (nonatomic, strong) UILabel *viewsLabel;
@property (nonatomic, strong) UILabel *bookmarksLabel;
@property (nonatomic, strong) UIImageView *bookmarksImageView;
@property (nonatomic, strong) UIImageView *viewsImageView;
@property (nonatomic, strong) UILabel *bottomSeparatorLabel;
@property (nonatomic, strong) UITextView *tagsTextView;
@end


#define coverPhotoSize 301
#define topPadding 2
#define bottomPadding 2
#define leftPadding 2;

#define placeholderText @"enter #tags"

@implementation ProfileStoryCell


- (UITextView *)tagsTextView {
    if (_tagsTextView == nil) {
        _tagsTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _tagsTextView.width = 500;
        _tagsTextView.height = 200;
        _tagsTextView.font = [UIFont h2];
        _tagsTextView.delegate = self;
        _tagsTextView.text = [NSString stringWithFormat:@"%@", placeholderText];
        _tagsTextView.textColor = [UIColor lightGrayColor];
    }
    return _tagsTextView;
}

- (UIImageView *)viewsImageView {
    if (_viewsImageView == nil) {
        _viewsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-cell-view"]];
    }
    return _viewsImageView;
}

- (UILabel *)viewsLabel {
    if (_viewsLabel == nil) {
        _viewsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _viewsLabel.font = [UIFont h3];
        _viewsLabel.textColor = [UIColor whiteColor];
        _viewsLabel.backgroundColor = [UIColor clearColor];
    }
    return _viewsLabel;
}

- (UIImageView *)bookmarksImageView {
    if (_bookmarksImageView == nil) {
        _bookmarksImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-cell-bookmark"]];
    }
    return _bookmarksImageView;
}

- (UILabel *)bookmarksLabel {
    if (_bookmarksLabel == nil) {
        _bookmarksLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bookmarksLabel.font = [UIFont h3];
        _bookmarksLabel.textColor = [UIColor whiteColor];
        _bookmarksLabel.backgroundColor = [UIColor clearColor];
    }
    return _bookmarksLabel;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.delegate.firstResponder isFirstResponder] && [touch view] != self.delegate.firstResponder) {
        [self.delegate.firstResponder resignFirstResponder];
        self.delegate.firstResponder = nil;
    }
    [super touchesBegan:touches withEvent:event];
}


- (UITextView *)titleTextView {
    if (_titleTextView == nil) {
        _titleTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _titleTextView.font = [UIFont fontWithName:@"MetaBoldLF-Roman" size:30];
        _titleTextView.textColor = [UIColor darkGrayColor];
        _titleTextView.scrollEnabled = NO;
        _titleTextView.delegate = self;
        _titleTextView.height = 45;
    }
    return _titleTextView;
}

- (UILabel *)bottomSeparatorLabel {
    if (_bottomSeparatorLabel == nil) {
        _bottomSeparatorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomSeparatorLabel.font = [UIFont h4];
        [_bottomSeparatorLabel autoSizeWithText:@". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ."]; //lmao
        _bottomSeparatorLabel.y = [ProfileStoryCell cellHeight] - _bottomSeparatorLabel.height;
        _bottomSeparatorLabel.centerX = [UIScreen mainScreen].bounds.size.width / 2; // why the fuck do i gotta do this
    }
    return _bottomSeparatorLabel;
}

- (void)prepareForReuse {
    self.bookmarksImageView.hidden = NO;
    self.bookmarksLabel.hidden = NO;
}

- (UIImageView *)coverPhotoImageView {
    if (_coverPhotoImageView == nil) {
        _coverPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _coverPhotoImageView.width = 256;
        _coverPhotoImageView.height = coverPhotoSize;
        _coverPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverPhotoImageView.clipsToBounds = YES;
        _coverPhotoImageView.x = leftPadding;
        _coverPhotoImageView.y = topPadding;
        UIView *blackOverlay = [[UIView alloc] initWithFrame:_coverPhotoImageView.bounds];
        blackOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [_coverPhotoImageView addSubview:blackOverlay];
        [self.viewsImageView putInBottomOf:_coverPhotoImageView withMargin:10];
        self.viewsImageView.x = 10;
        [self.bookmarksImageView putInBottomOf:_coverPhotoImageView withMargin:10];
    }
    return _coverPhotoImageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.layer.borderColor = [UIColor redColor].CGColor;
        //self.layer.borderWidth = 1.0f;
        [self addSubview:self.coverPhotoImageView];
        [self.titleTextView putToRightOf:self.coverPhotoImageView withMargin:20];
        self.titleTextView.width = UIScreen.mainScreen.bounds.size.width - self.titleTextView.x - 10;
        [self.coverPhotoImageView addSubview:self.viewsLabel];
        [self.coverPhotoImageView addSubview:self.bookmarksLabel];
        [self.tagsTextView putBelow:self.titleTextView withMargin:5];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (CGFloat)cellHeight {
    return coverPhotoSize + topPadding + bottomPadding;
}

- (void)renderWithStory: (Story *) story {
    //[self addSubview:self.bottomSeparatorLabel];
    self.story = story;
    self.titleTextView.text = story.title;
    [self.coverPhotoImageView setImageWithURL:[NSURL URLWithString:story.cover_url]];
    [self.viewsLabel autoSizeWithText:[NSString stringWithFormat:@"%@", story.views_count]];
    [self.viewsLabel putToRightOf:self.viewsImageView withMargin:10];
    self.viewsLabel.centerY = self.viewsImageView.centerY;
    
    if (story.bookmarks_count.intValue == 0) {
        self.bookmarksImageView.hidden = YES;
        self.bookmarksLabel.hidden = YES;
    } else {
        [self.bookmarksImageView putToRightOf:self.viewsLabel withMargin:15];
        [self.bookmarksLabel autoSizeWithText:[NSString stringWithFormat:@"%@", story.bookmarks_count]];
        [self.bookmarksLabel putToRightOf:self.bookmarksImageView withMargin:8];
    }
    if (story.tags && ![story.tags.trim isEqualToString:@""]) {
        self.tagsTextView.text = story.tags;
    }
}

- (NSArray *)tagsFromText: (NSString *) text {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
    NSLog(@"modified string: %@", modifiedString);
    
    return [modifiedString componentsSeparatedByString:@" "];
}

- (void)postTags:(NSString *)tagsString {
    self.story.tags = tagsString;
    [RKObjectManager.sharedManager
     putObject:self.story
     path:nil
     parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    }];
}

- (void)postStory {
    [RKObjectManager.sharedManager
     putObject:self.story
     path:nil
     parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
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
    [self.delegate performSelector:@selector(removeFirstResponder) withObject:textView];
    textView.text = [textView.text trim];
    if (textView == self.titleTextView) {
        if ([textView.text isEqualToString:@""]) {
            textView.text = self.story.title;
        } else if (![textView.text isEqualToString:self.story.title]) {
            self.story.title = textView.text;
            [self postStory];
        }
    } else if (textView == self.tagsTextView) {
        if ([[textView.text trim] isEqualToString:@""]) {
            textView.text = [NSString stringWithFormat:@"%@", placeholderText];
            textView.textColor = [UIColor lightGrayColor];
        } else if (![textView.text isEqualToString:self.story.tags]) {
            self.story.tags = textView.text;
            [self postStory];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.delegate performSelector:@selector(setFirstResponder:) withObject:textView];
    
    if (textView == self.tagsTextView) {
        textView.textColor = [UIColor darkGrayColor];
        if ([textView.text isEqualToString:placeholderText]) {
            textView.text = @"";
        }
    }
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // allow backspace always
    if ([text isEqualToString:@""]) {
        return YES;
    }
    
    if (textView == self.titleTextView) {
        NSError *error = NULL;
        NSRegularExpression *alphaRegex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z0-9: ]" options:NSRegularExpressionCaseInsensitive error:&error];
        if (![alphaRegex numberOfMatchesInString:text
                                         options:0
                                           range:NSMakeRange(0, [text length])]) {
            return NO;
        }
        return YES;
    } else if (textView == self.tagsTextView) {
        NSError *error = NULL;
        
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
    return YES;
}

@end
