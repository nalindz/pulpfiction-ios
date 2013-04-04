//
//  UploadStoryTutorialView.m
//  BookApp
//
//  Created by Nalin on 3/1/13.
//
//

#import "UploadStoryTutorialView.h"


@interface UploadStoryTutorialView()
@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) UIImageView *step1ImageView;
@property (nonatomic, strong) UIImageView *step2ImageView;
@property (nonatomic, strong) UIImageView *step3ImageView;
@property (nonatomic, strong) UILabel *step1Label;
@property (nonatomic, strong) UILabel *step2Label;
@property (nonatomic, strong) UILabel *step2NoteLabel;
@property (nonatomic, strong) UILabel *step3Label;
@property (nonatomic, strong) UIImageView *step1BulletImage;
@property (nonatomic, strong) UIImageView *step2BulletImage;
@property (nonatomic, strong) UIImageView *step3BulletImage;
@end

@implementation UploadStoryTutorialView

- (UILabel*) headerLabel {
    if (_headerLabel == nil) {
        _headerLabel = [[UILabel alloc] initWithBAStyle];
        _headerLabel.font = [UIFont h2];
        [_headerLabel autoSizeWithText:@"You have no uploaded stories. Here's how:"];
        _headerLabel.centerX =  self.center.x;
        _headerLabel.y = 50;
    }
    return _headerLabel;
}

- (UIImageView*) step1BulletImage {
    if (_step1BulletImage == nil) {
        _step1BulletImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upload-step-1-bullet"]];
    }
    return _step1BulletImage;
}

- (UIImageView*) step2BulletImage {
    if (_step2BulletImage == nil) {
        _step2BulletImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upload-step-2-bullet"]];
    }
    return _step2BulletImage;
}

- (UIImageView*) step3BulletImage {
    if (_step3BulletImage == nil) {
        _step3BulletImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upload-step-3-bullet"]];
    }
    return _step3BulletImage;
}

- (UIImageView*) step1ImageView {
    if (_step1ImageView == nil) {
        _step1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upload-step-1-image"]];
    }
    return _step1ImageView;
}

- (UIImageView*) step2ImageView {
    if (_step2ImageView == nil) {
        _step2ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upload-step-2-image"]];
    }
    return _step2ImageView;
}

- (UIImageView*) step3ImageView {
    if (_step3ImageView == nil) {
        _step3ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upload-step-3-image"]];
    }
    return _step3ImageView;
}

- (UILabel*) step1Label {
    if (_step1Label == nil) {
        _step1Label = [[UILabel alloc] initWithBAStyle];
        _step1Label.font = [UIFont h3];
        _step1Label.numberOfLines = 0;
        _step1Label.height = _step1Label.font.pointSize * 2 + 8;
        [_step1Label setText:[NSString stringWithFormat:@"Compose an email to:\n%@+%@@pulpfictionapp.com",
                              [API.sharedInstance.loggedInUser.username lowercaseString],
                              API.sharedInstance.loggedInUser.email_hash]
                                             fixedWidth:NO];
    }
    return _step1Label;
}

- (UILabel*) step2Label {
    if (_step2Label == nil) {
        _step2Label = [[UILabel alloc] initWithBAStyle];
        _step2Label.font = [UIFont h3];
        [_step2Label autoSizeWithText:@"Attach your story and a cover photo"];
    }
    return _step2Label;
}

- (UILabel*) step2NoteLabel {
    if (_step2NoteLabel == nil) {
        _step2NoteLabel = [[UILabel alloc] initWithBAStyle];
        _step2NoteLabel.font = [UIFont h5];
        [_step2NoteLabel autoSizeWithText:@"We support docx and txt formats"];
    }
    return _step2NoteLabel;
}

- (UILabel*) step3Label {
    if (_step3Label == nil) {
        _step3Label = [[UILabel alloc] initWithBAStyle];
        _step3Label.font = [UIFont h3];
        _step3Label.numberOfLines = 0;
        [_step3Label autoSizeWithText:@"Send it. Your story is published!\nCheck back here and #tag it!"];
        _step3Label.height = _step3Label.height - 8;
    }
    return _step3Label;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat bulletToLabelMargin = 30;
        CGFloat spacingBetweenSteps = 180;
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.headerLabel];
        self.step1BulletImage.y = 200;
        self.step1BulletImage.x = 40;
        [self addSubview:self.step1BulletImage];
        [self.step1Label putToRightOf:self.step1BulletImage withMargin:bulletToLabelMargin];
        [self.step1ImageView putInRightEdgeOf:self withMargin:80];
        self.step1ImageView.y = self.step1BulletImage.y;
        
        
        [self.step2BulletImage putBelow:self.step1BulletImage withMargin:spacingBetweenSteps];
        [self.step2Label putToRightOf:self.step2BulletImage withMargin:bulletToLabelMargin];
        [self.step2NoteLabel putBelow:self.step2Label withMargin:5];
        [self.step2ImageView putInRightEdgeOf:self withMargin:80];
        self.step2ImageView.centerY = self.step2BulletImage.center.y;
        self.step2ImageView.centerX = self.step1ImageView.center.x;
        
        [self.step3BulletImage putBelow:self.step2BulletImage withMargin:spacingBetweenSteps];
        [self.step3Label putToRightOf:self.step3BulletImage withMargin:bulletToLabelMargin];
        [self.step3ImageView putInRightEdgeOf:self withMargin:80];
        self.step3ImageView.centerY = self.step3Label.center.y;
        self.step3ImageView.centerX = self.step2ImageView.center.x;
        
    }
    return self;
}

@end
