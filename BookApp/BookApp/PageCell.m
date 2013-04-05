
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
@property (nonatomic, strong) UIView *titleBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *fontIncrease;
@property (nonatomic, strong) UIButton *fontDecrease;
@property (nonatomic, strong) UIButton *bookmarkButton;
@property (nonatomic, strong) NSNumber *pageNumber;
@property (nonatomic, strong) NSNumber *storyId;
@property (nonatomic) CGFloat margin;
@property (nonatomic, strong) BAProgressBarView *progressBar;

@end

@implementation PageCell

- (UIButton*) bookmarkButton {
    if (_bookmarkButton == nil) {
        _bookmarkButton = [UIButton initWithImageNamed:@"bookmark-button-light"];
        [_bookmarkButton addTarget:self.delegate action:@selector(bookmarkClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bookmarkButton;
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
        
        
        [self.bookmarkButton putInLeftEdgeOf:self withMargin:20];
        
        UITapGestureRecognizer *textTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleControls)];
        [self.textLabel addGestureRecognizer:textTap];
        
        self.titleBar = [[UIView alloc] init];
        self.titleBar.width = self.width;
        self.titleBar.height = 40;
        
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
    self.progressBar = [[BAProgressBarView alloc] initWithFrame:CGRectMake(self.margin * 2 ,self.height - 80, self.width - self.margin * 4, 50)];
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
    
    
    if (self.story.bookmark && ![self.story.bookmark.auto_bookmark boolValue]) {
        [self setPageBookmarked];
    }
    
    if (!showControls) {
        [self hideControls];
    } else {
        [self showControls];
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

- (void)showControls {
    self.progressBar.hidden = NO;
    self.fontDecrease.hidden = NO;
    self.fontIncrease.hidden = NO;
    self.backButton.hidden = NO;
    self.bookmarkButton.hidden = NO;
    [UIView animateWithDuration:0.15 animations:^{
        self.progressBar.alpha = 1.0;
        self.fontDecrease.alpha = 1.0;
        self.fontIncrease.alpha = 1.0;
        self.backButton.alpha = 1.0;
        self.bookmarkButton.alpha = 1.0;
    }];
}

- (void)hideControls {
    [UIView animateWithDuration:0.15 animations:^{
        self.progressBar.alpha = 0.0;
        self.fontDecrease.alpha = 0.0;
        self.fontIncrease.alpha = 0.0;
        self.backButton.alpha = 0.0;
        self.bookmarkButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.progressBar.hidden = YES;
        self.fontDecrease.hidden = YES;
        self.fontIncrease.hidden = YES;
        self.backButton.hidden = YES;
        self.bookmarkButton.hidden = YES;
    }];
}

- (void)enableFontButtons {
    self.fontDecrease.enabled = YES;
    self.fontIncrease.enabled = YES;
}

@end