//
//  SquashSecondViewController.h
//  SquashAlley
//
//  Created by Jack O'Shea on 7/13/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "SquashMasterViewController.h"
#import "SquashLadderGetter.h"


@interface SquashSecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView* ladderTable;
    IBOutlet UILabel* ladderInfo;
    IBOutlet UINavigationBar* bar;
    
    
    PFObject* currentProgram;
    NSArray* unsortedLadder;
    NSDictionary* unsortedLadderDict;
    NSMutableArray* sortedLadder;
    
}
- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath;
-(void)reloadPressed;


@end
