//
//  BaseSquashViewController.m
//  SquashAppBase
//
//  Created by Jack O'Shea on 11/8/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import "BaseSquashViewController.h"

@interface BaseSquashViewController ()

@end

@implementation BaseSquashViewController

-(void)setUpUI{
    
    
    UINavigationBar *theNavBar =  self.revealViewController.navigationController.navigationBar;
    
    theNavBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont fontWithName:@"Helvetica Light" size:20.0],UITextAttributeFont, nil];
    
    UIImage* reloadImage = [UIImage imageNamed:@"Reload.png"];
    UIBarButtonItem* reloadIcon = [[UIBarButtonItem alloc]initWithImage:reloadImage style:UIBarButtonItemStylePlain target:self.revealViewController.rearViewController action:@selector(reloadPressed)];
    self.revealViewController.navigationItem.rightBarButtonItem = reloadIcon;
    
    UIImage* leftImage = [UIImage imageNamed:@"Bars.png"];
    UIBarButtonItem* leftIcon = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggleAnimated:)];
    
    self.revealViewController.navigationItem.leftBarButtonItem = leftIcon;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //      SET COLOR HERE      SET COLOR HERE      SET COLOR HERE
    theNavBar.barTintColor = [UIColor colorWithRed:(255.0f/255.0f) green:(20.0f/255.0f) blue:(2.0f/255.0f) alpha:1.0f];
    self.navigationController.navigationBar.translucent = NO;
    
    self.revealViewController.rearViewRevealWidth = 180;
    
    self.revealViewController.title = @"Squash";
    
    
    self.revealViewController.delegate = self.revealViewController.rearViewController;

    
}

-(void)reloadPressed{
//    [(UIViewController*)[[self view] viewWithTag:1] viewDidLoad];
//    [(UIViewController*)[[self view]viewWithTag:1] viewDidAppear:YES];
    
}


-(void)changeViewTo:(UIViewController *)newView{
//    self transitionFromViewController:self toViewController:<#(UIViewController *)#> duration:<#(NSTimeInterval)#> options:<#(UIViewAnimationOptions)#> animations:<#^(void)animations#> completion:<#^(BOOL finished)completion#>
    
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    self.childViewController = sender;

    
}


- (void)viewDidLoad
{
    [self setUpUI];

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.childViewController = nil;
    UIViewController* newView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Ladder"];

    [self transitionFromViewController:self.childViewController toViewController:newView duration:0.01 options:UIViewAnimationOptionTransitionNone animations:nil completion:nil];
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
