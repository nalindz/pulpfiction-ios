//
//  Bookmark.m
//  BookApp
//
//  Created by Nalin on 11/18/12.
//
//

#import "Bookmark.h"

@implementation Bookmark

+ (NSEntityDescription *)entity
{
    return [NSEntityDescription entityForName:@"BABookmark" inManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription entityForName:@"BABookmark" inManagedObjectContext:context];
}

@end
