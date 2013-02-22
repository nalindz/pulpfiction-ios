//
//  SBLayout.m
//  BookApp
//
//  Created by Nalin on 11/26/12.
//
//

#import "SBLayout.h"


@interface SBLayout()
@property NSInteger cellCount;
@property CGFloat cellWidth;
@property CGFloat cellHeight;
@end


#define pageSize 9.0f


@implementation SBLayout

- (id)initWithBounds:(CGRect) bounds {
    self = [super init];
    if (self) {
        self.cellHeight = bounds.size.height / 3;
        self.cellWidth = bounds.size.width / 3;
    }
    return self;
}

- (CGSize)collectionViewContentSize {
    int numberOfPages = ceil([[self collectionView] numberOfItemsInSection:0] / pageSize);
    
    
    CGFloat width = [self collectionView].frame.size.width * numberOfPages;
    CGSize size = [self collectionView].frame.size;
    size.width = width;
    
    return size;
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.cellCount = [[self collectionView] numberOfItemsInSection:0];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    int page = indexPath.row / 9;
    int row = (indexPath.row  - page * pageSize)/ 3;
    int column = indexPath.row % 3;
    
    CGRect frame = CGRectZero;
    frame.origin.x = column * self.cellWidth + page * self.collectionView.frame.size.width;
    frame.origin.y = row * self.cellHeight;
    frame.size.width = self.cellWidth;
    frame.size.height = self.cellHeight;
    attributes.frame = frame;
    
    
    return attributes;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < self.cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }

    return attributes;
}


@end
