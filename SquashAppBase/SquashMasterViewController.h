//
//  SquashMasterViewController.h
//  SquashAppBase
//
//  Created by Jack O'Shea on 11/8/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "SquashDetailViewController.h"

@interface SquashMasterViewController : UITableViewController



@property (strong, nonatomic) SquashDetailViewController *detailViewController;

@end
