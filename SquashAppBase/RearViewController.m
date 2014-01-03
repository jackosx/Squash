//
//  RearViewController.m
//  SquashAppBase
//
//  Created by Jack O'Shea on 11/8/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import "RearViewController.h"

@interface RearViewController ()

@end

@implementation RearViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cellIDs = [NSArray arrayWithObjects:@"Home",@"Ladder",@"Calendar", nil];
        

        
    }
    return self;
}

-(NSArray*)getCellIDs{
    NSArray* theCellIDs = [[NSArray alloc]initWithObjects:@"Home",@"Ladder",@"Calendar", nil];
    
    return theCellIDs;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch(section) {
        case 0: //
            return [[self getCellIDs] count];
            break;
            
        case 1:
            return [programs count];
            break;
            
        default: //Not found
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = nil;
            break;
        case 1:
            sectionName = @"Select your group:";
            break;
            // ...
        default:
            sectionName = nil;
            break;
    }
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch(indexPath.section) {
        case 0: {
            NSString *CellIdentifier = [[self getCellIDs] objectAtIndex:indexPath.row];

            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            cell.backgroundColor = [UIColor colorWithRed:(239.0f/255.0f) green:(239.0f/255.0f) blue:(244.0f/255.0f) alpha:1.0f];
            
        
            return cell;
            
        }
            break;
            
        case 1: {
            
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProgramCell"];
            cell.backgroundColor = [UIColor colorWithRed:(239.0f/255.0f) green:(239.0f/255.0f) blue:(244.0f/255.0f) alpha:1.0f];

            UILabel* label = [cell viewWithTag:2];
            
            NSString* programName = [[programs objectAtIndex:indexPath.row]objectForKey:@"Name"];
            label.text = programName;
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSString* storedProgram = [defaults objectForKey:@"userProgram"];
            
            NSLog(@"Comparing %@ and %@",programName, [defaults objectForKey:@"userProgram"]);

            
            if ([storedProgram isEqualToString:programName]){
                UIView* selectedMarker = [cell viewWithTag:3];
                selectedMarker.alpha = 1;
            }
            
            return cell;
           
        }
            break;
            
        default: //Not found
            break;
    }
    return 0;
}



- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    NSLog(@"PREPARE FOR SEGUE");
    
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [viewList indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    self.revealViewController.title = segue.identifier;
    

    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            
            UIViewController* newController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:segue.identifier];
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:segue.identifier forKey:@"lastView"];
            currentViewController = newController;


            
            UINavigationController* baseController = (UINavigationController*)self.revealViewController.frontViewController;
                       [baseController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1){
        for(int i=0;i<[programs count];i++){
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:1]];
           UIView* selectedMarker = [cell viewWithTag:3];
            selectedMarker.alpha = 0;
        }
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        UIView* selectedMarker = [cell viewWithTag:3];
        selectedMarker.alpha = 1;
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSString* programName = [[programs objectAtIndex:indexPath.row]objectForKey:@"Name"];
        [defaults setObject:programName forKey:@"userProgram"];
        [defaults synchronize];
        NSLog(@"SAVED CHANGES");
        
    
    }
    
}

-(void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position{
}


-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position{
    
    if (position == FrontViewPositionLeft){
        [self reloadPressed];
    }
}

-(void)reloadPressed{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    currentViewID = [defaults objectForKey:@"lastView"];
    NSLog(@"RELOADING %@ VIEW",currentViewID);
    
        currentViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:currentViewID];
    
    
    
    UINavigationController* baseController = (UINavigationController*)self.revealViewController.frontViewController;
    [baseController setViewControllers: @[currentViewController] animated: NO ];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    PFQuery* programQuery = [PFQuery queryWithClassName:@"ProgramsList"];
    [programQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            programs = objects;
            [viewList reloadData];        }
     else {NSLog(@"Error: %@ %@", error, [error userInfo]);}
     }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
