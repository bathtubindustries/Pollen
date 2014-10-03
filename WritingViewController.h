//
//  WritingViewController.h
//  PollenBug
//
//  Created by Eric Nelson on 8/9/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface WritingViewController : UIViewController<UITextFieldDelegate>
{
    UITextField * activeField;
    CGSize kbSize;
    BOOL isAdjusted;
}
@property (retain, nonatomic) IBOutlet UITextField *firstInitial;
@property (retain, nonatomic) IBOutlet UITextField *secInitial;
@property (retain, nonatomic) IBOutlet UITextField *firstLine;
@property (retain, nonatomic) IBOutlet UITextField *secLine;
@property (retain, nonatomic) IBOutlet UITextField *thirdLine;
@property (retain, nonatomic) IBOutlet UIButton *submitButton;
@property (retain, nonatomic) IBOutlet UIButton *backButton;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) Firebase* root;

@end
