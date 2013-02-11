//
//  Searchable.h
//  BookApp
//
//  Created by Nalin on 2/10/13.
//
//

#import <Foundation/Foundation.h>

@protocol Searchable <NSObject>
- (void)search:(NSString *) searchText;
@end
