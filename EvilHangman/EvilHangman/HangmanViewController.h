//
//  HangmanViewController.h
//  EvilHangman
//
//  Created by Jeroen van der Es on 24-11-14.
//  Copyright (c) 2014 Jeroen van der Es. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HangmanViewController : UIViewController <UITextFieldDelegate>

{

IBOutlet UILabel *amountOfGuessesLeftLabel;
IBOutlet UILabel *placeHolderWord;
IBOutlet UIBarButtonItem *NewGame;
IBOutlet UITextField *typeField;
IBOutlet UILabel *guessedLettersLabel;
IBOutlet UILabel *explainLabel;
IBOutlet UIProgressView *guessesProgressBar;

    
}

@property (nonatomic, strong) IBOutlet UIProgressView *guessesProgressBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *NewGame;
@property (nonatomic, retain) IBOutlet UILabel *amountOfGuessesLeftLabel;
@property (strong, nonatomic) IBOutlet UITextField *typeField;
@property (nonatomic, retain) IBOutlet UILabel *placeHolderWord;
@property (nonatomic, retain) IBOutlet UILabel *guessedLettersLabel;
@property (nonatomic, retain) IBOutlet UILabel *explainLabel;



- (IBAction)NewGamePressed:(id)sender;
- (IBAction)unwindToHangman:(UIStoryboardSegue *)segue;



@end
