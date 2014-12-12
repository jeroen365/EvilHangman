//
//  GameFunctions.m
//  EvilHangman
//
//  Created by Jeroen van der Es on 10-12-14.
//  Copyright (c) 2014 Jeroen van der Es. All rights reserved.
//

#import "GameFunctions.h"

@implementation GameFunctions


static bool correct;
static bool win;
static bool lose;

NSMutableArray *words;
    
    
    
- (void) loadDictionary {
    // Load dictionary
    NSString *path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    words = [[NSMutableArray alloc] initWithContentsOfFile:path];
}



- (void)narrowDownToWordLength {
    // Delete all words longer & shorter than set length from array
    NSUserDefaults *Settings = [NSUserDefaults standardUserDefaults];
    int wordLength = (int)[Settings integerForKey:@"WordLength"];
    [words enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *word, NSUInteger index, BOOL *stop) {
        if ([word length] != wordLength ) {
            [words removeObjectAtIndex:index];
        }
        
    }];
}



/*- (void)equivalenceClasses:(NSString*)placeHolderWordText andOther: (NSString*)typeFieldText {
    // Set variables needed later
    NSString *input = [typeFieldText uppercaseString];
    NSMutableArray *indexSets = [[NSMutableArray alloc] init];
    NSMutableString *placeholders = [placeHolderWordText mutableCopy];
    NSUserDefaults *Settings = [NSUserDefaults standardUserDefaults];
    int wordLength = (int)[Settings integerForKey:@"WordLength"];
    
    
    
    // Go over every word and create indexSet of letter appearences in word
    for (NSString *word in words) {
        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
        for (NSInteger letter = 0; letter < wordLength; letter++) {
            unichar character = [word characterAtIndex:letter];
            if (character == [input characterAtIndex:0]) {
                [indexSet addIndex: letter];
                
            }
        }
        // Add indexSet to array of indexSets.
        [indexSets addObject:indexSet];
        
    }
    
    // Find most occurring set in array of sets (most occuring position of letter)
    NSCountedSet *sets = [NSCountedSet setWithArray:indexSets];
    //NSCountedSet *wordSetsCounted = [NSCountedSet setWithArray: wordSets];
    NSMutableArray *occurrences = [NSMutableArray array];
    for (NSIndexSet *set in sets) {
        NSDictionary *setsDictionary = @{@"set":set, @"count":@([sets countForObject:set])};
        [occurrences addObject:setsDictionary];
    }
    // Sort unique indexes by occurence, first index is most occuring.
    NSArray *sortedIndexCount = [occurrences sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO]]];
    // NSLog(@" hoi hoi %@", sortedIndexCount);
    
    NSIndexSet *locations = [sortedIndexCount[0] valueForKey:@"set"];
    // NSLog(@"locations %@", locations);
    
    // If largest indexSet contains any indexes, add a letter to the view
    if ([locations count] != 0 ) {
        for (int j = 0; j < wordLength ; j++) {
            if ([locations containsIndex:j]) {
                NSRange range = NSMakeRange(j, 1);
                [placeholders replaceCharactersInRange:range withString:input];
                correct = YES;
            }
        }
        
    }
    else {
        [self updateGuessesLeft];
        correct = NO;
    }
    // Update label in view
    placeHolderWordText = placeholders;
    
    // Remove all impossible words from wordlist for efficiency.
    NSMutableArray *wordsCopy = [words copy];
    for (NSString *word in wordsCopy) {
        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
        for (NSInteger letter = 0; letter < wordLength ; letter++) {
            unichar character = [word characterAtIndex:letter];
            if (character == [input characterAtIndex:0]) {
                [indexSet addIndex: letter];
            }
        }
        if ([indexSet isEqualToIndexSet:locations] == NO) {
            [words removeObject:word];
        }
    }
}*/




@end

