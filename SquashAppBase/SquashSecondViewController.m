//
//  SquashSecondViewController.m
//  SquashAlley
//
//  Created by Jack O'Shea on 7/13/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import "SquashSecondViewController.h"

@interface SquashSecondViewController ()

@end

@implementation SquashSecondViewController

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
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
//    self.view.
    
    
//    FAKE SETUP FAKE SETUP FAKE SETUP FAKE SETUP FAKE SETUP FAKE SETUP FAKE SETUP FAKE SETUP FAKE SETUP
//    FAKE SETUP FAKE SETUP FAKE SETUP FAKE SETUP FAKE SETUP FAKE SETUP FAKE SETUP FAKE SETUP FAKE SETUP
 
    
}

-(void)reloadPressed{
    NSLog(@"RELOADING");
    [self fakeViewDidAppear];
}

-(void)viewDidAppear:(BOOL)animated{
    [self fakeViewDidAppear];
}

-(void)fakeViewDidAppear{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    if (![defaults objectForKey:@"LadderAuthenticated"]){
        UIViewController* passwordController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Password"];
        [self presentViewController:passwordController animated:YES completion:nil];
    }
    
    
    
    PFQuery* programQuery = [PFQuery queryWithClassName:@"ProgramsList"];
    NSArray* programsList = [programQuery findObjects];
    
    if (![defaults objectForKey:@"userProgram"]){
        PFObject* firstObject = [programQuery getFirstObject];
        [defaults setObject:[firstObject objectForKey:@"Name"] forKey:@"userProgram"];
        
    }
 
    NSString* compareString = [defaults objectForKey:@"userProgram"];
    NSLog(@"LOOKING FOR %@ ",compareString);
    
    
    
    for (int i = 0; i < [programsList count]; i++){
        if ([[[programsList objectAtIndex:i] objectForKey:@"Name"] isEqualToString:compareString]){
            currentProgram = [programsList objectAtIndex:i];
            ladderInfo.text = [currentProgram objectForKey:@"LadderInfo"];
        }
    }
    
    NSString* ladderGroupTitle = [currentProgram objectForKey:@"Ladder"];
    
    //sortedLadder = [myParser getLadderForGroup:ladderGroupTitle];
    
    PFQuery* ladderQuery = [PFQuery queryWithClassName:ladderGroupTitle];
    [ladderQuery orderByAscending:@"Rank"];
    [ladderQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            sortedLadder = objects;
            [ladderTable reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    [ladderTable reloadData];
    
    

}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 70.0;
}


- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerID"];
    
    id playerObject = [sortedLadder objectAtIndex:[indexPath row]];
    
    UILabel* nameLabel = [cell viewWithTag:2];
    NSString* nameString = [playerObject objectForKey:@"Name"];
    [nameLabel setText:nameString];

    UILabel* detailLabel = [cell viewWithTag:3];
    NSString* detailString = [playerObject objectForKey:@"Other"];
    [detailLabel setText:detailString];
    
    UIImageView* playerPictureView = [cell viewWithTag:4];
    [[playerObject objectForKey:@"Picture"]getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *playerImage = [UIImage imageWithData:imageData];
            [playerPictureView setImage:playerImage];

        }
    }];


    UILabel* rankingLabel = [cell viewWithTag:1];
    [rankingLabel setText:[NSString stringWithFormat:@"%d",[indexPath row]+1 ]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    return [sortedLadder count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
