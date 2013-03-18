//
//  StoryView+RestKit.m
//  BookApp
//
//  Created by Nalin on 2/13/13.
//
//

#import "StoryView+RestKit.h"

@implementation StoryView (RestKit)
+ (void)configureRestKitMapping {
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[StoryView class]
                                             pathPattern:@"/stories/:story_id/view"
                                             method:RKRequestMethodPOST]];
}
@end
