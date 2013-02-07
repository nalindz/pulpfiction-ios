
//  SlideViewCell.m
//  BookApp
//
//  Created by Nalin on 11/5/12.
//
//

#import "SlideViewCell.h"
#import "BAProgressBarView.h"
#import "Story+RestKit.h"
#import "Block+RestKit.h"

@interface SlideViewCell()
@property (nonatomic, strong) UIView *titleBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *fontIncrease;
@property (nonatomic, strong) UIButton *fontDecrease;
@property (nonatomic, strong) NSNumber *pageNumber;
@property (nonatomic, strong) NSNumber *storyId;
@property (nonatomic, strong) BAProgressBarView *progressBar;

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
        
        UITapGestureRecognizer *textTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleControls)];
        [self addGestureRecognizer:textTap];
        
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
        [self.fontIncrease autoSizeWithText:@"+" fixedWidth:NO];
        [self.fontIncrease positionLeftOf:self.backButton withMargin:20];
        [self.fontIncrease addTarget:self action:@selector(clickedFontIncrease) forControlEvents:UIControlEventTouchUpInside];
        self.fontIncrease.height = self.backButton.height;
        [self addSubview:self.fontIncrease];
        
        
        self.fontDecrease = [[UIButton alloc] init];
        self.fontDecrease.titleLabel.font =[UIFont fontWithName:@"MetaBoldLF-Roman" size:30];
        [self.fontDecrease setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.fontDecrease autoSizeWithText:@"-" fixedWidth:NO];
        self.fontDecrease.width = self.fontDecrease.width + 15;
        [self.fontDecrease positionLeftOf:self.fontIncrease withMargin:20];
        [self.fontDecrease addTarget:self action:@selector(clickedFontDecrease) forControlEvents:UIControlEventTouchUpInside];
        self.fontDecrease.height = self.backButton.height;
        [self addSubview:self.fontDecrease];
        
        
        
    }
    return self;
}




- (void) clickedFontIncrease {
    //self.fontIncrease.enabled = NO;
    [self.delegate fontIncrease];
}

- (void) clickedFontDecrease {
//    self.fontDecrease.enabled = NO;
    [self.delegate fontDecrease];
}


- (void)prepareForReuse {
    self.transform = CGAffineTransformIdentity;
    self.textLabel.text = @"";
    self.delegate = nil;
    [self.progressBar removeFromSuperview];
    [self showControls];
}



- (void)renderWithPageNumber: (NSNumber *) pageNumber
                     storyId: (NSNumber *) storyId
                        font: (UIFont *) font
                      margin: (CGFloat) margin
                showControls: (BOOL) showControls {
    
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
    Story *story = [Story findFirstByAttribute:@"id" withValue:storyId];
    Block *firstBlock = [Block blockWithStoryId:storyId blockNumber:page.first_block_number];
    Block *lastBlock = [Block blockWithStoryId:storyId blockNumber:page.last_block_number];
    
    CGFloat progress = ([lastBlock.total_start_index floatValue] + [page.last_block_index floatValue]) / [story.total_length floatValue];
    
    
    NSLog(@"progress :%f", progress);
    NSLog(@"firstBlock total start index :%f", [firstBlock.total_start_index floatValue]);
    NSLog(@"page first block index :%f", [page.first_block_index floatValue]);
    
    self.progressBar = [[BAProgressBarView alloc] initWithFrame:CGRectMake(margin * 2 ,self.height - 80, self.width - margin * 4, 50)];
    [self.progressBar setPercentage:progress];
    [self addSubview:self.progressBar];
    if (!showControls) {
        [self hideControls];
    } else {
        [self showControls];
    }
}

- (void) toggleControls {
    
    NSLog(@"meoww");
    if (self.progressBar.hidden) {
        [self.delegate showAllControls];
    } else {
        [self.delegate hideAllControls];
    }
}

- (void) showControls {
    self.progressBar.hidden = NO;
    self.fontDecrease.hidden = NO;
    self.fontIncrease.hidden = NO;
    self.backButton.hidden = NO;
    [UIView animateWithDuration:0.15 animations:^{
        self.progressBar.alpha = 1.0;
        self.fontDecrease.alpha = 1.0;
        self.fontIncrease.alpha = 1.0;
        self.backButton.alpha = 1.0;
    }];
}

- (void) hideControls {
    [UIView animateWithDuration:0.15 animations:^{
        self.progressBar.alpha = 0.0;
        self.fontDecrease.alpha = 0.0;
        self.fontIncrease.alpha = 0.0;
        self.backButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.progressBar.hidden = YES;
        self.fontDecrease.hidden = YES;
        self.fontIncrease.hidden = YES;
        self.backButton.hidden = YES;
    }];
}


- (void)enableFontButtons {
    self.fontDecrease.enabled = YES;
    self.fontIncrease.enabled = YES;
}


@end
