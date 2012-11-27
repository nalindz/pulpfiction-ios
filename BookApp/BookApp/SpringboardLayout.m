//
//  SpringboardLayout.m
//  BookApp
//
//  Created by Nalin on 11/26/12.
//
//

#import "SpringboardLayout.h"

@implementation SpringboardLayout

- (id)init
{
    if (self = [super init])
    {
        //self.itemSize = CGSizeMake(144, 144);
        //self.minimumInteritemSpacing = 48;
        //self.minimumLineSpacing = 48;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //self.sectionInset = UIEdgeInsetsMake(32, 32, 32, 32);
    }
    return self;
}

@end
