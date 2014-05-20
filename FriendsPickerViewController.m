//
//  FriendsPickerViewController.m
//  PollenBug
//
//  Created by Eric Nelson on 5/19/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "FriendsPickerViewController.h"

#define kPlayerKey @"player"
#define kScoreKey @"score"
#define kIsChallengedKey @"isChallenged"

#define kCheckMarkTag 4

@interface FriendsPickerViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
GameKitHelperProtocol> {
    
    NSMutableDictionary *_dataSource;
    int64_t _score;
}

@end

@implementation FriendsPickerViewController


- (id)initWithScore:(int64_t) score {
    self = [super
            initWithNibName:
            @"FriendsPickerViewController"
            bundle:nil];
    
    if (self) {
        _score = score;
        
        [_dataSource initWithDictionary:[NSMutableDictionary dictionary]];
        NSLog(@"Dicti init");
        GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
        
        gameKitHelper.delegate = self;
        [gameKitHelper findScoresOfFriendsToChallenge];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton =
    [[UIBarButtonItem alloc]
     initWithTitle:@"Cancel"
     style:UIBarButtonItemStylePlain
     target:self
     action:@selector(cancelButtonPressed:)];
    
    UIBarButtonItem *challengeButton =
    [[UIBarButtonItem alloc]
     initWithTitle:@"Challenge"
     style:UIBarButtonItemStylePlain
     target:self
     action:@selector(challengeButtonPressed:)];
    
    self.navigationItem.leftBarButtonItem =
    cancelButton;
    self.navigationItem.rightBarButtonItem =
    challengeButton;
}


-(void)
onScoresOfFriendsToChallengeListReceived:
(NSArray*) scores {
    //1
    NSMutableArray *playerIds =
    [NSMutableArray array];
    
    //2
    [scores enumerateObjectsUsingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop){
         
         GKScore *score = (GKScore*) obj;
         
         
         //3
         if (_dataSource != [NSDictionary dictionary]){
         if(_dataSource[score.playerID]
            == nil) {
             _dataSource[score.playerID] =
             [NSMutableDictionary dictionary];
             [playerIds addObject:score.playerID];
         }
         
         //4
         if (score.value < _score) {
             [_dataSource[score.playerID]
              setObject:[NSNumber numberWithBool:YES]
              forKey:kIsChallengedKey];
         }
         
         //5
         [_dataSource[score.playerID]
          setObject:score forKey:kScoreKey];
         }
     }];
    
    //6
    [[GameKitHelper sharedGameKitHelper]
     getPlayerInfo:playerIds];
     
    [self.tableView reloadData];
     
}

-(void) onPlayerInfoReceived:(NSArray*)players {
    //1
    
    [players
     enumerateObjectsUsingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop) {
         
         GKPlayer *player = (GKPlayer*)obj;
         
         //2
         if (_dataSource[player.playerID]
             == nil) {
             _dataSource[player.playerID] =
             [NSMutableDictionary dictionary];
         }
         [_dataSource[player.playerID]
          setObject:player forKey:kPlayerKey];
         
         //3
         [self.tableView reloadData];
     }];
}







- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell identifier";
    static int ScoreLabelTag = 1;
    static int PlayerImageTag = 2;
    static int PlayerNameTag = 3;
    
    UITableViewCell *tableViewCell =
    [tableView
     dequeueReusableCellWithIdentifier:
     CellIdentifier];
    
    if (!tableViewCell) {
        
        tableViewCell =
        [[UITableViewCell alloc]
         initWithStyle:UITableViewCellStyleDefault
         reuseIdentifier:CellIdentifier];
        tableViewCell.selectionStyle =
        UITableViewCellSelectionStyleGray;
        tableViewCell.textLabel.textColor =
        [UIColor whiteColor];
        
        UILabel *playerName =
        [[UILabel alloc] initWithFrame:
         CGRectMake(50, 0, 150, 44)];
        playerName.tag = PlayerNameTag;
        playerName.font = [UIFont systemFontOfSize:18];
        playerName.backgroundColor =
        [UIColor clearColor];
        playerName.textAlignment =
        UIControlContentVerticalAlignmentCenter;
        [tableViewCell addSubview:playerName];
        
        UIImageView *playerImage =
        [[UIImageView alloc]
         initWithFrame:CGRectMake(0, 0, 44, 44)];
        playerImage.tag = PlayerImageTag;
        [tableViewCell addSubview:playerImage];
        
        UILabel *scoreLabel =
        [[UILabel alloc]
         initWithFrame:
         CGRectMake(395, 0, 30,
                    tableViewCell.frame.size.height)];
        
        scoreLabel.tag = ScoreLabelTag;
        scoreLabel.backgroundColor =
        [UIColor clearColor];
        scoreLabel.textColor =
        [UIColor whiteColor];
        [tableViewCell.contentView
         addSubview:scoreLabel];
        
        UIImageView *checkmark =
        [[UIImageView alloc]
         initWithImage:[UIImage
                        imageNamed:@"checkmark.png"]];
        checkmark.tag = kCheckMarkTag;
        checkmark.hidden = YES;
        CGRect frame = checkmark.frame;
        frame.origin =
        CGPointMake(tableView.frame.size.width - 16, 13);
        checkmark.frame = frame;
        [tableViewCell.contentView
         addSubview:checkmark];
    }
    NSDictionary *dict =
    [_dataSource allValues][indexPath.row];
    GKScore *score = dict[kScoreKey];
    GKPlayer *player = dict[kPlayerKey];
    
    NSNumber *number = dict[kIsChallengedKey];
    
    UIImageView *checkmark =
    (UIImageView*)[tableViewCell
                   viewWithTag:kCheckMarkTag];
    
    if ([number boolValue] == YES) {
        checkmark.hidden = NO;
    } else {
        checkmark.hidden = YES;
    }
    
    [player
     loadPhotoForSize:GKPhotoSizeSmall
     withCompletionHandler:
     ^(UIImage *photo, NSError *error) {
         if (!error) {
             UIImageView *playerImage =
             (UIImageView*)[tableView
                            viewWithTag:PlayerImageTag];
             playerImage.image = photo;
         } else {
             NSLog(@"Error loading image");
         }
     }];
    
    UILabel *playerName =
    (UILabel*)[tableViewCell
               viewWithTag:PlayerNameTag];
    playerName.text = player.displayName;
    
    UILabel *scoreLabel =
    (UILabel*)[tableViewCell
               viewWithTag:ScoreLabelTag];
    scoreLabel.text = score.formattedValue;
    return tableViewCell;
}




- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:
(NSIndexPath *)indexPath {
    
    BOOL isChallenged = NO;
    
    //1
    UITableViewCell *tableViewCell =
    [tableView cellForRowAtIndexPath:
     indexPath];
    
    //2
    UIImageView *checkmark =
    (UIImageView*)[tableViewCell
                   viewWithTag:kCheckMarkTag];
    
    //3
    if (checkmark.isHidden == NO) {
        checkmark.hidden = YES;
    } else {
        checkmark.hidden = NO;
        isChallenged = YES;
    }
    NSArray *array =
    [_dataSource allValues];
    
    NSMutableDictionary *dict =
    array[indexPath.row];
    
    //4
    [dict setObject:[NSNumber
                     numberWithBool:isChallenged]
             forKey:kIsChallengedKey];
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}








- (void)cancelButtonPressed:(id) sender {
    if (self.cancelButtonPressedBlock != nil) {
        self.cancelButtonPressedBlock();
    }
}

- (void)challengeButtonPressed:(id) sender {
    if (self.challengeButtonPressedBlock) {
        self.challengeButtonPressedBlock();
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_bgImage release];
    
    [_challengeMessage release];
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBgImage:nil];
   
    [self setChallengeMessage:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
