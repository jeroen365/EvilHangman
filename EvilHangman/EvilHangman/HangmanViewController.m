//
//  HangmanViewController.m
//  EvilHangman
//
//  Created by Jeroen van der Es on 24-11-14.
//  Copyright (c) 2014 Jeroen van der Es. All rights reserved.
//

#import "HangmanViewController.h"
#import "GameFunctions.h"


@interface HangmanViewController () {
    GameFunctions* gameFunctions;
}

@property (nonatomic, readwrite, strong) NSMutableArray *words;
@property (nonatomic, readwrite, strong) NSMutableArray *guessedLetters;
@property (nonatomic, readwrite, strong) NSMutableArray *viableWords;

@end



@implementation HangmanViewController

@synthesize amountOfGuessesLeftLabel, typeField, placeHolderWord, NewGame, guessedLettersLabel, guessedLetters, explainLabel, guessesProgressBar, words, viableWords;


static bool correct;
static bool win;
static bool lose;

NSNumber *wordLength;
NSNumber *amountOfGuesses;



- (void) setup{
    
    NSUserDefaults *Settings = [NSUserDefaults standardUserDefaults];
    
    [typeField becomeFirstResponder];
    
    
    
    //Initialize Amount of Guesses at start up
    int amountOfGuesses = (int)[Settings integerForKey:@"AmountOfGuesses"];
    NSString *amountOfGuessesString = [NSString stringWithFormat:@"Guesses left: %i", amountOfGuesses];
    amountOfGuessesLeftLabel.text = amountOfGuessesString;
    guessesProgressBar.progress = 1.0f;
    
    
    // Initialize label (placeholder) with hyphens (length as saved in NSUserDefaults)
    int wordLength = (int)[Settings integerForKey:@"WordLength"];
    NSString *placeholders = [@"-" stringByPaddingToLength:wordLength withString:@"-" startingAtIndex:0];
    placeHolderWord.text = placeholders;
    
    win = NO;
    lose = NO;
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    // Give instructions for the game
    explainLabel.text = @"Enter a letter and press return to start playing";
    explainLabel.textColor = [UIColor blackColor];
    explainLabel.font = [UIFont systemFontOfSize:15];
    self.view.tintColor = [UIColor colorWithRed:0.0f
                                          green:122.0f/255.0f
                                           blue:1.0f
                                          alpha:1.0f];
    
    
    // Fill label with guessed letters to all letters 'unguessed'
    guessedLetters= [[NSMutableArray alloc] init];
    NSArray *alphabet = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    for (NSString *character in alphabet) {
        NSMutableDictionary *letter = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       character, @"letter",
                                       [UIColor blackColor], @"color",
                                       [NSNumber numberWithBool:NO], @"guessed", nil];
        [guessedLetters addObject:letter];
    }
    NSString *guessedLettersString = [alphabet componentsJoinedByString:@" "];
    guessedLettersLabel.text = guessedLettersString;
    
    // Load dictionairy
    NSString *path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    words = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    
    // Configure dictionary to preferences
    [self narrowDownToWordLength];
    
    
}



- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    gameFunctions = [GameFunctions new];
    // Do any additional setup after loading the view.
    [self setup];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // Limit input to 1 character
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength > 1){
        return NO;
    }
    
    // Prevents a crashing undo bug
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    // Limit useable character set to alfabetic characters only
    if (textField == typeField) {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else {
        return YES;
    }
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *input = [textField.text uppercaseString];
    for (NSDictionary *letter in guessedLetters) {
        if ([[letter valueForKey:@"letter"] isEqualToString:input]) {
            if ([[letter valueForKey:@"guessed"] isEqualToValue:[NSNumber numberWithBool:YES]]) {
                explainLabel.text = @"You cannot enter the same letter twice!\n Try again.";
                typeField.text = @"";
                return NO;
            }
            else {
                [self equivalenceClasses];
                [self updateGuessedLettersLabel];
                typeField.text = @"";
                if (correct == YES) {
                    explainLabel.text = @"Correct! Enter another letter.";
                    [self checkForWin];
                    if (win == YES) {
                        [self showWinScreen];
                    }
                }
                else {
                    explainLabel.text = @"Wrong! Try again.";
                    if (lose == YES) {
                        [self showLoseScreen];
                    }
                }
                return YES;
            }
        }
    }
    
    explainLabel.text = @"You must enter one letter per turn!\n Try again.";
    typeField.text = @"";
    return NO;
    
    
    return YES;
}


- (IBAction)NewGamePressed:(id)sender
{
    [self setup];
    
}

- (void)equivalenceClasses {
    // Set variables needed later
    NSString *input = [typeField.text uppercaseString];
    NSMutableArray *indexSets = [[NSMutableArray alloc] init];
    NSMutableString *placeholders = [placeHolderWord.text mutableCopy];
    NSUserDefaults *Settings = [NSUserDefaults standardUserDefaults];
    int wordLength = (int)[Settings integerForKey:@"WordLength"];
    
    
    
    // Go over every word and create indexSet of letter appearences in word
    for (NSString *word in words) {
        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
        for (NSInteger letter = 0; letter < wordLength; letter++) {
            unichar character = [word characterAtIndex:letter];
            if (character == [input characterAtIndex:0]) {
                [indexSet addIndex: letter];
                [viableWords addObject: word];
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
    placeHolderWord.text = placeholders;
    
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
}


- (void)updateGuessedLettersLabel {
    // Go over the letters of the alphabet (stored in guessedLetters) and change colors to grey when a letter is guessed
    NSString *input = [typeField.text uppercaseString];
    NSString *labelText = guessedLettersLabel.text;
    NSDictionary *labelTextAttributes = @{NSForegroundColorAttributeName: guessedLettersLabel.textColor,
                                          };
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:labelText
                                                                                       attributes: labelTextAttributes];
    for (NSMutableDictionary *letter in guessedLetters) {
        if ([[letter valueForKey:@"letter"] isEqualToString:input]) {
            // Update letter's data
            [letter setValue:[UIColor whiteColor] forKey:@"color"];
            [letter setValue:[NSNumber numberWithBool:YES] forKey:@"guessed"];
        }
        // Update UI
        UIColor *letterColor = [letter valueForKey:@"color"];
        NSRange letterTextRange = [labelText rangeOfString:[letter valueForKey:@"letter"]];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:letterColor}
                                range:letterTextRange];
    }
    guessedLettersLabel.attributedText = attributedText;
}


- (void)updateGuessesLeft {
    NSUserDefaults *Settings = [NSUserDefaults standardUserDefaults];
    int amountOfGuesses = (int)[Settings integerForKey:@"AmountOfGuesses"];
    
    // Retreive number of guesses left from labelGuessesLeft
    NSString *labelTextGuessesLeft = amountOfGuessesLeftLabel.text;
    NSMutableCharacterSet *nonNumberCharacterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    [nonNumberCharacterSet invert];
    NSString *filtered = [[labelTextGuessesLeft componentsSeparatedByCharactersInSet:nonNumberCharacterSet] componentsJoinedByString:@""];
    
    
    
    int amountOfGuessesLeft = [filtered intValue] - 1;
    int guessesLeft = guessesProgressBar.progress * 100;
    NSLog(@"guessesleft %i", guessesLeft);
    int downPerGuess = 100 / amountOfGuesses ;
    guessesLeft = (guessesLeft - downPerGuess);
    
    // Update both Progressview and Label
    [guessesProgressBar setProgress:((float)guessesLeft / 100) animated:YES];
    amountOfGuessesLeftLabel.text = [NSString stringWithFormat:@"Guesses Left: %i", amountOfGuessesLeft];
    
    // If user is out of guesses, game lost
    if (amountOfGuessesLeft == 0) {
        [guessesProgressBar setProgress:0.0f animated:YES];
        lose = YES;
    }
}

- (void)checkForWin {
    NSString *placeholder = placeHolderWord.text;
    if ([placeholder rangeOfString:@"-" ].location == NSNotFound) {
        win = YES;
    }
}

- (void)showWinScreen {
    explainLabel.text = @"Congratulations, you win!";
    explainLabel.font = [UIFont systemFontOfSize:20];
    UIColor *winGreen = [UIColor colorWithRed:0.0f
                                        green:180.0f/255.0f
                                         blue:0.0f
                                        alpha:1.0f];
    explainLabel.textColor = winGreen;
    self.view.tintColor = winGreen;
    [typeField resignFirstResponder];
}

- (void)showLoseScreen {
    explainLabel.text = @"Oh no, you lost!\n The word was:";
    explainLabel.font = [UIFont systemFontOfSize:20];
    explainLabel.textColor = [UIColor redColor];
    self.view.tintColor = [UIColor redColor];
    
    // Pick random word from words left in wordlist
    int lastIndex = [words count] - 1;
    int randomNumber = arc4random_uniform(lastIndex);
    placeHolderWord.text = [words objectAtIndex:randomNumber];
    [typeField resignFirstResponder];
}

- (IBAction)unwindToHangman:(UIStoryboardSegue *)segue
{
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
