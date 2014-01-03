//
//  SquashCalendarViewController.h
//  SquashAlley
//
//  Created by Jack O'Shea on 9/4/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquashParser.h"
#import <Parse/Parse.h>


@interface SquashCalendarViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
{
    int eventCount;
    int todayCount;
    int weekCount;
    int laterCount;
    PFObject* currentProgram;
    IBOutlet UICollectionView* collectionView;
    NSMutableArray* events;
    NSMutableArray* eventsToday;
    NSMutableArray* eventsWeek;
    NSMutableArray* eventsLater;
}

-(void)reloadPressed;

@end
