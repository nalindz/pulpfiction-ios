#import "CaptureView.h"

// Private
@interface CaptureView (/* Private */)
- (void)settingImageFromView:(UIView *)view;
@end

// Public
@implementation CaptureView

@synthesize imageCapture = _imageCapture;

// Standard
- (id)initWithFrame:(CGRect)frame {

    if ((self = [super initWithFrame:frame])) {
        // Initialization code.
    }
    return self;
}

// Init
- (id)initWithView:(UIView *)view {
//    if ((self = [super initWithFrame:[view frame]])) {
    if ((self = [super initWithFrame: CGRectMake(0, 0,150,200)])) {
        // Initialization code.
        [self settingImageFromView:view];
    }
    return self;  
}


- (void)settingImageFromView:(UIView *)view {
//    CGRect rect = [view bounds];  
    CGRect rect = CGRectMake(100, 150,150,200);  
    UIGraphicsBeginImageContext(rect.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();  
    [view.layer renderInContext:context];  
    UIImage *imageCaptureRect;

    imageCaptureRect = UIGraphicsGetImageFromCurrentImageContext();  
    _imageCapture = imageCaptureRect;
//    _imageCapture = UIGraphicsGetImageFromCurrentImageContext();  
//    [_imageCapture retain];
    UIGraphicsEndImageContext();   
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
    CGPoint accPoint = CGPointMake(0,0);
    [_imageCapture drawAtPoint:accPoint];
}


- (void)dealloc {
    [_imageCapture release];
    [super dealloc];
}

@end