
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
@property (nonatomic, strong) UIButton *fontIncrease;
@property (nonatomic, strong) UIButton *fontDecrease;
@property (nonatomic, strong) NSNumber *pageNumber;
@property (nonatomic, strong) NSNumber *storyId;

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
        
        self.titleBar = [[UIView alloc] init];
        self.titleBar.width = self.width;
        self.titleBar.height = 40;
        
        self.backButton = [[UIButton alloc] init];
        [self.backButton autoSizeWithImage:@"close-button"];
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
}


- (void)renderWithPageNumber: (NSNumber *) pageNumber
                     storyId: (NSNumber *) storyId
                        font: (UIFont *) font
                      margin: (CGFloat) margin {
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enableFontButtons)
                                                 name:@"enableFontButons"
                                               object:nil];
}

- (void)enableFontButtons {
    self.fontDecrease.enabled = YES;
    self.fontIncrease.enabled = YES;
}


@end
