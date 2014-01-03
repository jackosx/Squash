//
//  RearViewController.h
//  SquashAppBase
//
//  Created by Jack O'Shea on 11/8/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquashSecondViewController.h"
#import "SquashMasterViewController.h"
#import "SWRevealViewController.h"
#import "BaseSquashViewController.h"

@interface RearViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,SWRevealViewControllerDelegate> {
    IBOutlet UITableView* viewList;
    IBOutlet UIPickerView* programsList;
    
    UIViewController* currentViewController;
    NSString* currentViewID;
    
    NSArray* programs;
    NSArray* cellIDs;
}

//@property (nonatomic, strong) NSArray *cellIDs;

@end
