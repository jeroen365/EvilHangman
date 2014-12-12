//
//  GameFunctions.h
//  EvilHangman
//
//  Created by Jeroen van der Es on 10-12-14.
//  Copyright (c) 2014 Jeroen van der Es. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameFunctions : NSObject


- (void)equivalenceClasses:(NSString*)placeHolderWordText andOther: (NSString*)typeFieldText;

- (void)narrowDownToWordLength;

- (void)loadDictionary;

@end
