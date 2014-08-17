//
//  WritingViewController.m
//  PollenBug
//
//  Created by Eric Nelson on 8/9/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "WritingViewController.h"
#import "GameUtility.h"


@interface WritingViewController ()

@end

@implementation WritingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.root = [[Firebase alloc] initWithUrl:@"https://ytl3fdvvuk7.firebaseio-demo.com/Haikus"];
    
    self.firstInitial.delegate=self;
    self.firstLine.delegate=self;
    self.secInitial.delegate=self;
    self.secLine.delegate=self;
    self.thirdLine.delegate=self;
    
    [self.firstInitial setReturnKeyType:UIReturnKeyDone];
    [self.firstLine setReturnKeyType:UIReturnKeyDone];
    [self.secLine setReturnKeyType:UIReturnKeyDone];
    [self.thirdLine setReturnKeyType:UIReturnKeyDone];
    [self.secInitial setReturnKeyType:UIReturnKeyDone];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)submitPressed:(id)sender {

    Firebase *newPoemRef =  [self.root childByAutoId];
    
    if (!self.firstLine.text || !self.secLine.text || !self.thirdLine.text
        || !self.firstInitial.text || !self.secInitial.text || !self.firstInitial.text  )
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Haiku Not Submitted" message:@"A field is missing" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease];
        
        [alert show];
    }
    else if ([GameUtility firebaseHaikuCount] ==0 )
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Not connected" message:@"Haiku not submitted. Check your connection and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease];
        
        [alert show];
    }
    
    else{
        NSDictionary *haiku1  =@{
                                 @"firstLine":self.firstLine.text,
                                 @"secLine": self.secLine.text,
                                 @"thirdLine" : self.thirdLine.text,
                                 @"firstInit": self.firstInitial.text,
                                 @"secInit": self.secInitial.text,
                                 @"approved": @"no"
                                };
        
        [newPoemRef setValue:haiku1];
        
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Haiku Submitted" message:@"Cool, thanks. If your haiku is 5-7-5 and not incredibly offensive, we will add it to the game's collection within a day!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease];
        
        [alert show];
    }
    
}
- (IBAction)backPressed:(id)sender {
    [[CCDirector sharedDirector] dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_firstInitial release];
    [_secInitial release];
    [_firstLine release];
    [_secLine release];
    [_thirdLine release];
    [_submitButton release];
    [_backButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFirstInitial:nil];
    [self setSecInitial:nil];
    [self setFirstLine:nil];
    [self setSecLine:nil];
    [self setThirdLine:nil];
    [self setSubmitButton:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
}
@end
