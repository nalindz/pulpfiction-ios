
//  SlideViewCell.m
//  BookApp
//
//  Created by Nalin on 11/5/12.
//
//

#import "PageCell.h"
#import "Story+RestKit.h"
#import "Block+RestKit.h"
#import "Bookmark+RestKit.h"

@interface PageCell()
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *fontIncrease;
@property (nonatomic, strong) UIButton *fontDecrease;
@property (nonatomic, strong) UIButton *bookmarkButton;
@property (nonatomic, strong) NSNumber *pageNumber;
@property (nonatomic, strong) NSNumber *storyId;
@property (nonatomic) CGFloat margin;
@property (nonatomic, strong) BAProgressBarView *progressBar;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PageCell

- (UIButton*) bookmarkButton {
    if (_bookmarkButton == nil) {
        _bookmarkButton = [UIButton initWithImageNamed:@"bookmark-button-light"];
        [_bookmarkButton addTarget:self.delegate action:@selector(bookmarkClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bookmarkButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont fontWithName:@"Meta Serif OT" size:18];
    }
    return _titleLabel;
}

- (void)setPageBookmarked {
    [self.bookmarkButton setImage:[UIImage imageNamed:@"bookmark-button-dark"] forState:UIControlStateNormal];
}

- (void)setPageUnbookmarked {
    [self.bookmarkButton setImage:[UIImage imageNamed:@"bookmark-button-light"] forState:UIControlStateNormal];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.numberOfLines = 0;
        self.textLabel.userInteractionEnabled = YES;
        [self addSubview:self.textLabel];
        [self addSubview:self.titleLabel];
        
        [self.bookmarkButton putInLeftEdgeOf:self withMargin:20];
        
        UITapGestureRecognizer *textTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleControls)];
        [self.textLabel addGestureRecognizer:textTap];
        
        self.backButton = [UIButton initWithImageNamed:@"close-button"];
        self.backButton.x = self.width - self.backButton.width - 20;
        [self.backButton addTarget:self.delegate action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.backButton];
        self.backButton.y = 20;
        
        self.fontIncrease = [[UIButton alloc] init];
        self.fontIncrease.titleLabel.font =[UIFont fontWithName:@"MetaBoldLF-Roman" size:30];
        [self.fontIncrease setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.fontIncrease autoSizeWithText:@"A" fixedWidth:NO];
        
        
        [self.fontIncrease addTarget:self action:@selector(clickedFontIncrease) forControlEvents:UIControlEventTouchUpInside];
        self.fontIncrease.height = self.backButton.height;
        
        self.fontDecrease = [[UIButton alloc] init];
        self.fontDecrease.titleLabel.font =[UIFont fontWithName:@"MetaBoldLF-Roman" size:30];
        [self.fontDecrease setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.fontDecrease autoSizeWithText:@"a" fixedWidth:NO];
        self.fontDecrease.width = self.fontDecrease.width + 15;
        
        
        [self.fontDecrease addTarget:self action:@selector(clickedFontDecrease) forControlEvents:UIControlEventTouchUpInside];
        self.fontDecrease.height = self.backButton.height;
    }
    return self;
}

- (void)clickedFontIncrease {
    [self.delegate fontIncrease];
}

- (void) clickedFontDecrease {
    [self.delegate fontDecrease];
}

- (void)prepareForReuse {
    self.transform = CGAffineTransformIdentity;
    self.textLabel.text = @"";
    self.delegate = nil;
    self.tag = -1;
    [self.progressBar removeFromSuperview];
    [self showControls];
    [self setPageUnbookmarked];
}

- (Story *) story {
    return [Story findFirstByAttribute:@"id" withValue:self.storyId];
}

- (void)renderProgressBarWithProgress: (CGFloat) progress {
    self.progressBar = [[BAProgressBarView alloc] initWithFrame:[self.delegate progressBarFrameForPageCell]];
    self.progressBar.delegate = self;
    [self.progressBar setPercentage:progress];
    [self addSubview:self.progressBar];
}

- (void)renderWithPageNumber: (NSNumber *) pageNumber
                     storyId: (NSNumber *) storyId
                        font: (UIFont *) font
                      margin: (CGFloat) margin
                      progress: (CGFloat) progress
                showControls: (BOOL) showControls {
    
    CGAffineTransform currentTransform = self.transform;
    self.transform = CGAffineTransformIdentity;
    self.storyId = storyId;
    self.pageNumber = pageNumber;
    self.margin = margin;
    
    Page *page = [Page findFirstWithPredicate:[NSPredicate predicateWithFormat:@"page_number == %@ AND story_id == %@", self.pageNumber, self.storyId]];
    self.textLabel.font = font;
    [self.textLabel positionCenterOf:self withMargin:margin];
    self.textLabel.text = page.text;
    self.transform = currentTransform;
    
    [self renderProgressBarWithProgress:progress];
    
    [self.fontDecrease positionLeftOf:self.progressBar withMargin:20];
    self.fontDecrease.centerY = self.progressBar.centerY + 15;
    [self.fontIncrease putToRightOf:self.progressBar withMargin:20];
    self.fontIncrease.centerY = self.progressBar.centerY + 15;
    
    
    [self.titleLabel autoSizeWithText:self.story.title];
    [self.titleLabel putInTopOf:self withMargin:27];
    self.titleLabel.centerX = self.width / 2;
    
    
    if (self.story.bookmark && ![self.story.bookmark.auto_bookmark boolValue]) {
        [self setPageBookmarked];
    }
    
    if (showControls) {
        [self showControls];
    } else {
        [self hideControls];
    }
}

- (void)setPercentage: (CGFloat) percentage {
    [self.progressBar setPercentage:percentage];
}

- (void)scrollToPercentage:(CGFloat)percentage {
    [self.delegate scrollToPercentage:percentage];
}

- (void)toggleControls {
    if (self.progressBar.hidden) {
        [self.delegate showAllControls];
    } else {
        [self.delegate hideAllControls];
    }
}

- (NSArray *)controls {
    return @[self.progressBar,
             self.fontDecrease,
             self.fontIncrease,
             self.backButton,
             self.bookmarkButton,
             self.titleLabel];
}

- (void)showControls {
    for (UIView *control in self.controls)
        control.hidden = NO;
    [UIView animateWithDuration:0.15 animations:^{
        for (UIView *control in self.controls)
            control.alpha = 1.0;
    }];
}

- (void)hideControls {
    [UIView animateWithDuration:0.15 animations:^{
        for (UIView *control in self.controls)
            control.alpha = 0.0;
    } completion:^(BOOL finished) {
        for (UIView *control in self.controls)
            control.hidden = YES;
    }];
}

- (void)enableFontButtons {
    self.fontDecrease.enabled = YES;
    self.fontIncrease.enabled = YES;
}

@end