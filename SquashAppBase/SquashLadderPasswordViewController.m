//
//  SquashLadderPasswordViewController.m
//  SquashAppBase
//
//  Created by Jack O'Shea on 11/12/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import "SquashLadderPasswordViewController.h"

@interface SquashLadderPasswordViewController ()

@end

@implementation SquashLadderPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)doneEditing:(id)sender {

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"donePressed %@", textField.text);
    if ([[textField text] isEqualToString:@"whiteknight"]){
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"LadderAuthenticated"];
        return YES;
    }
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [passField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
