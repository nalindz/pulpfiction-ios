//
//  NSString+RemoveExtraWhiteSpace.m
//  BookApp
//
//  Created by Nalin on 2/2/13.
//
//

#import "NSString+RemoveExtraWhiteSpace.h"

@implementation NSString (RemoveExtraWhiteSpace)

- (NSString *) trim {
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [self componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    return [filteredArray componentsJoinedByString:@" "];
}


- (BOOL)isBlank {
    return [[self trim] isEqualToString:@""];
}

@end
