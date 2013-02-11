//
//  BAProgressBarView.m
//  BookApp
//
//  Created by Nalin on 12/6/12.
//
//

#import "BAProgressBarView.h"

@interface BAProgressBarView()
@property (nonatomic, strong) NSMutableArray *dotArray;

@end

@implementation BAProgressBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *nonActiveDot = [[UILabel alloc] init];
        nonActiveDot.font = [UIFont fontWithName:@"Meta Serif OT" size:50];
        [nonActiveDot setText:@"." fixedWidth:NO];
        self.dotArray = [[NSMutableArray alloc] init];
        int numTotalDots = self.width / nonActiveDot.width;
        
        for (int i = 0; i < numTotalDots; i++ ) {
            UILabel *dotToAdd = [[UILabel alloc] init];
            dotToAdd.userInteractionEnabled = YES;
            dotToAdd.tag = (i * 100) / numTotalDots;
            UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotTap:)];
            [dotToAdd addGestureRecognizer:recognizer];
            dotToAdd.backgroundColor = [UIColor clearColor];
            dotToAdd.height = 50;
            dotToAdd.textColor = [UIColor lightGrayColor];
            dotToAdd.font = [UIFont fontWithName:@"Meta Serif OT" size:50];
            [dotToAdd setText:@"." fixedWidth:NO];
            dotToAdd.x = i * dotToAdd.width;
            [self addSubview:dotToAdd];
        }
        self.height = 50;
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
    }
    return self;
}

- (void) dotTap: (UITapGestureRecognizer *) recognizer {
    [self.delegate scrollToPercentage:(recognizer.view.tag / 100.0)];
}


- (void) setPercentage: (CGFloat) percentage {
    int i = 0.0f;
    for (UILabel *dot in self.subviews) {
        if ((i / (CGFloat)self.subviews.count) < percentage) {
            dot.textColor = [UIColor blackColor];
        } else {
            dot.textColor = [UIColor lightGrayColor];
        }
        i = 1.0f + i;
    }
}


@end
