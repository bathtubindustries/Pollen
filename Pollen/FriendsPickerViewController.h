//
//  FriendsPickerViewController.h
//  PollenBug
//
//  Created by Eric Nelson on 5/19/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void
(^FriendsPickerCancelButtonPressed)();
typedef void
(^FriendsPickerChallengeButtonPressed)();

@interface FriendsPickerViewController : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIImageView *bgImage;


@property (retain, nonatomic) IBOutlet UITextField *challengeMessage;

//1
@property (nonatomic, copy)
FriendsPickerCancelButtonPressed
cancelButtonPressedBlock;

//2
@property (nonatomic, copy)
FriendsPickerChallengeButtonPressed
challengeButtonPressedBlock;
-(id)initWithScore:(int64_t) score;
-(void)onScoresOfFriendsToChallengeListReceived:(NSArray*) scores;
-(void) onPlayerInfoReceived:(NSArray*)players ;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
