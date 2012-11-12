//
//  Page.m
//  BookApp
//
//  Created by Nalin on 11/11/12.
//
//

#import "Page.h"

@implementation Page

+ (NSEntityDescription *)entity
{
    return [NSEntityDescription entityForName:@"BAPage" inManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]];
}

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription entityForName:@"BAPage" inManagedObjectContext:context];
}


@end
