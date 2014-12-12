//
//  SettingsViewController.h
//  EvilHangman
//
//  Created by Jeroen van der Es on 24-11-14.
//  Copyright (c) 2014 Jeroen van der Es. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
{

IBOutlet UISlider *wordLengthSlider;
IBOutlet UILabel *wordLengthTextField;
IBOutlet UISlider *amountOfGuessesSlider;
IBOutlet UILabel *amountOfGuessesTextField;
    
    
}


@property (nonatomic, retain) IBOutlet UISlider *wordLengthSlider;
@property (nonatomic, retain) IBOutlet UILabel *wordLengthTextField;
@property (nonatomic, retain) IBOutlet UISlider *amountOfGuessesSlider;
@property (nonatomic, retain) IBOutlet UILabel *amountOfGuessesTextField;


- (IBAction) WordLengthSliderValueChanged:(id)sender;
- (IBAction) GuessesSliderValueChanged:(id)sender;






@end

