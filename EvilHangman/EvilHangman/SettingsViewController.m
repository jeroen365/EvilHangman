//
//  SettingsViewController.m
//  EvilHangman
//
//  Created by Jeroen van der Es on 24-11-14.
//  Copyright (c) 2014 Jeroen van der Es. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize wordLengthSlider, wordLengthTextField, amountOfGuessesSlider, amountOfGuessesTextField;


- (IBAction) WordLengthSliderValueChanged:(UISlider *)sender {
    float wordLengthFloat = [sender value];
    int wordLengthInt = (int)(wordLengthFloat);
    wordLengthTextField.text = [NSString stringWithFormat:@"%i", wordLengthInt];
    NSUserDefaults *Settings = [NSUserDefaults standardUserDefaults];
    [Settings setInteger: wordLengthInt forKey:@"WordLength"];
    
    [Settings synchronize];
    
    
}


- (IBAction) GuessesSliderValueChanged:(UISlider *)sender {
    
    float AmountOfGuessesFloat = [sender value];
    int AmountOfGuessesInt = (int)(AmountOfGuessesFloat);
    amountOfGuessesTextField.text = [NSString stringWithFormat:@"%i", AmountOfGuessesInt];
    NSUserDefaults *Settings = [NSUserDefaults standardUserDefaults];
    
    [Settings setInteger: AmountOfGuessesInt forKey:@"AmountOfGuesses"];
    
    [Settings synchronize];
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    if (wordLengthTextField) {
        if ([wordLengthTextField canResignFirstResponder]) [wordLengthTextField resignFirstResponder];
    }
    [super touchesBegan: touches withEvent: event];
}

- (void)viewDidLoad {
    
    
    NSUserDefaults *Settings = [NSUserDefaults standardUserDefaults];
    
    int wordLengthInt = (int)[Settings integerForKey:@"WordLength"];
    int amountOfGuessesInt = (int)[Settings integerForKey:@"AmountOfGuesses"];
    
    NSString *amountOfGuessesString = [NSString stringWithFormat:@"%i", amountOfGuessesInt];
    NSString *wordLengthString = [NSString stringWithFormat:@"%i", wordLengthInt];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSArray *wordList = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    
   // Find maximum and minimum word length in words.plist
    NSNumber *maximumLength = [wordList valueForKeyPath:@"@max.length"];
    NSNumber *minimumLength = [wordList valueForKeyPath:@"@min.length"];
    
    // Set slider's maximum value to maximum word length
    wordLengthSlider.maximumValue = [maximumLength floatValue];
    wordLengthSlider.minimumValue = [minimumLength floatValue];
    
    amountOfGuessesSlider.value = amountOfGuessesInt;
    amountOfGuessesTextField.text = amountOfGuessesString;
    wordLengthSlider.value = wordLengthInt;
    wordLengthTextField.text = wordLengthString;
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
