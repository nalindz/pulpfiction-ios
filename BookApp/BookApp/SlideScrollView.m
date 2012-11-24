//
//  SlideScrollView.m
//  BookApp
//
//  Created by Nalin on 11/6/12.
//
//

#import "SlideScrollView.h"

@implementation UIView (PSCollectionView)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end




@interface SlideScrollView()

@property (nonatomic, assign, readwrite) CGFloat colWidth;
@property (nonatomic, assign, readwrite) NSInteger numCols;
@property (nonatomic, assign) UIInterfaceOrientation orientation;

@property (nonatomic, retain) NSMutableSet *reuseableViews;
@property (nonatomic, retain) NSMutableDictionary *visibleViews;
@property (nonatomic, retain) NSMutableArray *viewKeysToRemove;
@property (nonatomic, retain) NSMutableDictionary *indexToRectMap;


- (void)removeAndAddCellsIfNecessary;
    

@end

@implementation SlideScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.colWidth = 0.0;
        self.numCols = 0;
        self.orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        self.reuseableViews = [NSMutableSet set];
        self.visibleViews = [NSMutableDictionary dictionary];
        self.viewKeysToRemove = [NSMutableArray array];
        self.indexToRectMap = [NSMutableDictionary dictionary];
        
    }
    return self;
}


- (void)enqueueReusableView:(SlideViewCell *)view {
    if ([view respondsToSelector:@selector(prepareForReuse)]) {
        [view performSelector:@selector(prepareForReuse)];
    }
    view.frame = CGRectZero;
    [self.reuseableViews addObject:view];
    [view removeFromSuperview];
}




- (void)relayoutViews: (BOOL) allViews {
    
    // Reset all state
    if (allViews) {
        [self.visibleViews enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            SlideViewCell *view = (SlideViewCell *)obj;
            [self enqueueReusableView:view];
        }];
        [self.visibleViews removeAllObjects];
        [self.viewKeysToRemove removeAllObjects];
    }
    
    [self.indexToRectMap removeAllObjects];
    
    
    /*
    if (self.emptyView) {
        [self.emptyView removeFromSuperview];
    }
     
    [self.loadingView removeFromSuperview];
     */
    
    // This is where we should layout the entire grid first
    NSInteger numViews = [self.dataSource numberOfPages];
    
    CGFloat totalWidth = 0.0;
    
    if (numViews > 0) {
        for (NSInteger i = 0; i < numViews; i++) {
            NSString *key = [NSString stringWithFormat:@"%d", i];
            
            CGRect viewRect = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            
            totalWidth += viewRect.size.width;
            
            // Add to index rect map
            [self.indexToRectMap setObject:NSStringFromCGRect(viewRect) forKey:key];
        }
    }
    self.contentSize = CGSizeMake(totalWidth, self.frame.size.height);
    
    [self removeAndAddCellsIfNecessary];
}

- (void)removeAndAddCellsIfNecessary {
    static NSInteger bufferViewFactor = 5;
    static NSInteger topIndex = 0;
    static NSInteger bottomIndex = 0;
    
    NSInteger numViews = [self.dataSource numberOfPages];
    
    if (numViews == 0) return;
    
    // Find out what rows are visible
    CGRect visibleRect = CGRectMake(self.contentOffset.x - 100, self.contentOffset.y, self.frame.size.width + 200, self.frame.size.height);
    
    // Remove all rows that are not inside the visible rect
    [self.visibleViews enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        SlideViewCell *view = (SlideViewCell *)obj;
        CGRect viewRect = view.frame;
        if (!CGRectIntersectsRect(visibleRect, viewRect)) {
            [self enqueueReusableView:view];
            [self.viewKeysToRemove addObject:key];
        }
    }];
    
    [self.visibleViews removeObjectsForKeys:self.viewKeysToRemove];
    [self.viewKeysToRemove removeAllObjects];
    
    if ([self.visibleViews count] == 0) {
        topIndex = 0;
        bottomIndex = numViews;
    } else {
        NSArray *sortedKeys = [[self.visibleViews allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            } else {
                return (NSComparisonResult)NSOrderedSame;
            }
        }];
        topIndex = [[sortedKeys objectAtIndex:0] integerValue];
        bottomIndex = [[sortedKeys lastObject] integerValue];
        
        topIndex = MAX(0, topIndex - bufferViewFactor);
        bottomIndex = MIN(numViews, bottomIndex + bufferViewFactor);
    }
    //    NSLog(@"topIndex: %d, bottomIndex: %d", topIndex, bottomIndex);
    
    // Add views
    for (NSInteger i = topIndex; i < bottomIndex; i++) {
        NSString *key = [NSString stringWithFormat:@"%d", i];
        
        CGRect rect = CGRectFromString([self.indexToRectMap objectForKey:key]);
        
        // If view is within visible rect and is not already shown
        if (![self.visibleViews objectForKey:key] && CGRectIntersectsRect(visibleRect, rect)) {
            // Only add views if not visible
            SlideViewCell *newView = [self.dataSource viewAtIndex:i];
            newView.transform = CGAffineTransformIdentity;
            newView.frame = CGRectFromString([self.indexToRectMap objectForKey:key]);
            [self addSubview:newView];
            
            /*
            // Setup gesture recognizer
            if ([newView.gestureRecognizers count] == 0) {
                PSCollectionViewTapGestureRecognizer *gr = [[[PSCollectionViewTapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectView:)] autorelease];
                gr.delegate = self;
                [newView addGestureRecognizer:gr];
                newView.userInteractionEnabled = YES;
            }
            */
            
            [self.visibleViews setObject:newView forKey:key];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self removeAndAddCellsIfNecessary];
}

- (void) reloadData {
    [self relayoutViews:YES];
}

- (void)loadNewData {
    [self relayoutViews:NO];
}

- (void)reloadIndex: (int) index {
    SlideViewCell *cell = [self.visibleViews objectForKey:[NSString stringWithFormat:@"%d", index]];
    if (cell != nil) {
        [cell reRender];
    }
}



@end
