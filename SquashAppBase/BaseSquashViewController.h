//
//  BaseSquashViewController.h
//  SquashAppBase
//
//  Created by Jack O'Shea on 11/8/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "SquashMasterViewController.h"
#import "SquashSecondViewController.h"
#import "RearViewController.h"

@interface BaseSquashViewController : UINavigationController{
    IBOutlet UIView *theView;
    NSMutableArray* events;
    PFObject* currentProgram;

}

@property (strong, nonatomic) UIViewController *childViewController;

-(void)changeViewTo:(UIViewController*)newView;

@end
