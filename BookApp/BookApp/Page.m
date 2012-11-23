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

- (Page *) unfault {
    Page *retrievedPage = (Page *)[[Page currentContext] objectWithID:self.objectID];
    Page *unfaultedPage = [Page findFirstWithPredicate:[NSPredicate predicateWithFormat:@"page_number == %@ AND story_id == %@", retrievedPage.page_number, retrievedPage.story_id]];
    return unfaultedPage;
}


@end
