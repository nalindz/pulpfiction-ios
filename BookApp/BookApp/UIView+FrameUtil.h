//
//  UIView+frameSetters.h
//  TagMe
//
//  Created by Nalin on 10/27/12.
//  Copyright (c) 2012 Tagged, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameUtil)

@property int height;
@property int width;
@property int x;
@property int y;

- (void) setHeight: (int) height;
- (void) setWidth: (int) width;
- (void) setX: (int) x;
- (void) setY: (int) y;
    
@end
