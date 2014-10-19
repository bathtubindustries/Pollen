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
    
    isAdjusted=NO;
    
    [self.firstInitial setReturnKeyType:UIReturnKeyDone];
    [self.firstLine setReturnKeyType:UIReturnKeyDone];
    [self.secLine setReturnKeyType:UIReturnKeyDone];
    [self.thirdLine setReturnKeyType:UIReturnKeyDone];
    [self.secInitial setReturnKeyType:UIReturnKeyDone];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];

    
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    
    activeField = textField;
    
    if(!isAdjusted) {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        
        self.scrollView.contentInset = contentInsets;
    
        self.scrollView.scrollIndicatorInsets = contentInsets;
    
        if (([activeField isEqual:self.thirdLine] || [activeField isEqual:self.secLine]))
        {
            
            CGPoint scrollPoint = CGPointMake(0.0, self.thirdLine.frame.origin.y - (kbSize.height - self.thirdLine.frame.size.height));
            [self.scrollView setContentOffset:scrollPoint animated:YES];
            isAdjusted=YES;
        }
        
    }

    
}

// Called when the UIKeyboardDidShowNotification is sent.

- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
    NSDictionary* info = [aNotification userInfo];
    
    kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    self.scrollView.contentInset = contentInsets;
    
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbSize.height;
    
    if (([activeField isEqual:self.thirdLine] || [activeField isEqual:self.secLine]) && !isAdjusted)
    {
    
    CGPoint scrollPoint = CGPointMake(0.0, self.thirdLine.frame.origin.y - (kbSize.height - self.thirdLine.frame.size.height));
    [self.scrollView setContentOffset:scrollPoint animated:NO];
        isAdjusted=YES;
    }
    
}



// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    self.scrollView.contentInset = contentInsets;
    
    self.scrollView.scrollIndicatorInsets = contentInsets;
    isAdjusted=NO;
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    activeField = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL) aFieldIsEmpty
{
    return ([self.firstInitial.text isEqualToString:@""] || [self.secInitial.text isEqualToString:@""] || [self.firstLine.text isEqualToString:@""]|| [self.secLine.text isEqualToString:@""]|| [self.thirdLine.text isEqualToString:@""]);
}


- (IBAction)submitPressed:(id)sender {

    Firebase *newPoemRef =  [self.root childByAutoId];
    
    if (!self.firstLine.text || !self.secLine.text || !self.thirdLine.text
        || !self.firstInitial.text || !self.secInitial.text || !self.firstInitial.text || [self aFieldIsEmpty] )
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
        [[CCDirector sharedDirector] dismissModalViewControllerAnimated:YES];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
