//
//  GameFunctions.m
//  EvilHangman
//
//  Created by Jeroen van der Es on 10-12-14.
//  Copyright (c) 2014 Jeroen van der Es. All rights reserved.
//

#import "GameFunctions.h"

@implementation GameFunctions

int wordLength;
NSMutableArray *words;
    
- (NSString*)initializeAmountOfGuesses{
    NSUserDefaults *Settings = [NSUserDefaults standardUserDefaults];
    int amountOfGuesses = (int)[Settings integerForKey:@"AmountOfGuesses"];
    NSString *amountOfGuessesString = [NSString stringWithFormat:@"Guesses left: %i", amountOfGuesses];
    return amountOfGuessesString;
}

- (NSString*)initializeWordLength {
    NSUserDefaults *Settings = [NSUserDefaults standardUserDefaults];
    int wordLength = (int)[Settings integerForKey:@"WordLength"];
    NSString *placeholders = [@"-" stringByPaddingToLength:wordLength withString:@"-" startingAtIndex:0];
    return placeholders;
}
- (NSMutableArray*) loadDictionary {
    // Load dictionary
    NSString *path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    words = [[NSMutableArray alloc] initWithContentsOfFile:path];
    return words;
}



- (NSMutableArray*)narrowDownToWordLength {
    // Delete all words longer & shorter than set length from array
    NSUserDefaults *Settings = [NSUserDefaults standardUserDefaults];
    int wordLength = (int)[Settings integerForKey:@"WordLength"];
    [words enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *word, NSUInteger index, BOOL *stop) {
        if ([word length] != wordLength ) {
            [words removeObjectAtIndex:index];
        }
        
    }];
    return words;
}



@end

