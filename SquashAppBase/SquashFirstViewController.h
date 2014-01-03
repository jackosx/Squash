//
//  SquashFirstViewController.h
//  SquashAlley
//
//  Created by Jack O'Shea on 7/13/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquashFirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSUserDefaults* defaults;
    NSArray* announcements;
    IBOutlet UITableView* tableViewRef;
    NSArray* newsArray;
    
    IBOutlet UILabel* articleTitleView;
    IBOutlet UILabel* articleDateView;
    IBOutlet UITextView* articleBodyView;
    IBOutlet UIImageView* articleImage;
    
}

-(void)reloadPressed;


@end
