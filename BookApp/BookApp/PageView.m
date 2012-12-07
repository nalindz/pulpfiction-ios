//
//  PageView.m
//  BookApp
//
//  Created by Nalin on 12/6/12.
//
//

#import "PageView.h"

@implementation PageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat offset = self.contentOffset.x;
    
    for (UIView *view in self.subviews) {
        CGFloat width = self.frame.size.width;
        int i = view.frame.origin.x / width;
        CGFloat y = i * width;
        CGFloat value = (offset-y)/width;
        CGFloat scale = 1.f-fabs(value);
        if (scale > 1.f) scale = 1.f;
        if (scale < .8f) scale = .8f;
        
        view.transform = CGAffineTransformMakeScale(scale, scale);
        
        CALayer *layer = view.layer;
        layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
