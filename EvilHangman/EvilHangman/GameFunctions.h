//
//  GameFunctions.h
//  EvilHangman
//
//  Created by Jeroen van der Es on 10-12-14.
//  Copyright (c) 2014 Jeroen van der Es. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameFunctions : NSObject

- (NSString*)initializeAmountOfGuesses;

- (NSString*)initializeWordLength;

- (NSMutableArray*)narrowDownToWordLength;

- (NSMutableArray*)loadDictionary;

- (NSMutableDictionary*)orderWords:(NSString*)input;

- (NSMutableArray*)largestEQClass:(NSMutableDictionary*)dictionary;
@end
