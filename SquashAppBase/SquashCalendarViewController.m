//
//  SquashCalendarViewController.m
//  SquashAlley
//
//  Created by Jack O'Shea on 9/4/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import "SquashCalendarViewController.h"

@interface SquashCalendarViewController ()

@end

@implementation SquashCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    
}

-(void)doCalendar{
    
    NSLog(@"THERE ARE %D EVENTS",[events count]);
    
    
    
    NSSortDescriptor *dateDesc = [[NSSortDescriptor alloc] initWithKey:@"StartDate" ascending:YES];
    NSArray *dateDescArray = [NSArray arrayWithObject:dateDesc];
    
    for (int i =0; i<[events count]; i++) {
        NSDate* dateToChange =  [[events objectAtIndex:i] objectForKey:@"StartDate"];
        NSTimeInterval secondsInEightHours = 5 * 60 * 60;
        NSDate *changedDate = [dateToChange dateByAddingTimeInterval:secondsInEightHours];
        [[events objectAtIndex:i]setObject:changedDate forKey:@"StartDate"];
    }
    
    [self removeOldDatesFromArray:events];


    for (int i =0; i<[events count]; i++) {
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[[events objectAtIndex:i] objectForKey:@"StartDate"]];
        
        NSLog(@"\nTesting date: %d \n day:%d",i,[otherDay day]);
        
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        if([today day] == [otherDay day] &&
           [today month] == [otherDay month] &&
           [today year] == [otherDay year] &&
           [today era] == [otherDay era]) {
            //do stuff for today
            todayCount++;
            [eventsToday addObject:[events objectAtIndex:i]];
            [events removeObjectAtIndex:i];
            i--;
            
            otherDay = nil;
            NSLog(@"SomethingToday;");
            
            
        }
        
    }
    
    for (int i =0; i<[events count]; i++) {
        
        if ([(NSDate*)[[events objectAtIndex:i]objectForKey:@"StartDate"]timeIntervalSinceNow] < 604800 && [(NSDate*)[[events objectAtIndex:i]objectForKey:@"StartDate"]timeIntervalSinceNow] > 0){
            //do stuff
            weekCount;
            NSLog(@"Something tomorrow");
            [eventsWeek addObject:[events objectAtIndex:i]];
            [events removeObjectAtIndex:i];
            i--;
            
        }
        
    }
    

    
    for (int i =0; i<[events count]; i++) {
        
        if ([(NSDate*)[[events objectAtIndex:i]objectForKey:@"StartDate"]timeIntervalSinceNow] < 604800 && [(NSDate*)[[events objectAtIndex:i]objectForKey:@"StartDate"]timeIntervalSinceNow] > 0){
            //do stuff
            NSLog(@"Something tomorrow");
            [eventsWeek addObject:[events objectAtIndex:i]];
            [events removeObjectAtIndex:i];
            i--;
            
        }
        
    }
    
    for (int i =0; i<[events count]; i++) {
        
             //do stuff
            [eventsLater addObject:[events objectAtIndex:i]];
            [events removeObjectAtIndex:i];
            i--;
        
    }

    
    
    [eventsLater addObjectsFromArray:events];
    laterCount = laterCount + [events count];
    
    
    NSLog(@"TODAY %d and %d",[eventsToday count],todayCount);
    
    [collectionView reloadData];
//    [collectionView layoutSubviews];
    
}

-(void)removeOldDatesFromArray:(NSMutableArray*)arrayToParse{
//    NSLog(@"THERE ARE %d DATES BEFORE REMOVAL",[events count]);
    for (int i =0; i<[arrayToParse count]; i++) {
//        NSLog(@"TIMEINTERVAL %f",[(NSDate*)[[arrayToParse objectAtIndex:i] objectForKey:@"StartDate"] timeIntervalSinceNow]);
        
        
        if ([(NSDate*)[[arrayToParse objectAtIndex:i] objectForKey:@"StartDate"] timeIntervalSinceNow] < 0.0){
            NSLog(@"Old");
            [arrayToParse removeObjectAtIndex:i];
            i--;
            
        }
        
    }

}

-(void)addDatesToday:(NSMutableArray*)arrayToParse{}

-(void)viewDidAppear:(BOOL)animated{
    events = [NSMutableArray new];
    
    if (!eventsToday) {
        eventsToday = [NSMutableArray new];
    }
    if(!eventsWeek){
        eventsWeek = [NSMutableArray new];
    }
    if (!eventsLater) {
        eventsLater = [NSMutableArray new];
    }

    events = [NSMutableArray new];
    [self downloadCalendar];

    
    NSSortDescriptor *dateDesc = [[NSSortDescriptor alloc] initWithKey:@"StartDate" ascending:YES];
    NSArray *dateDescArray = [NSArray arrayWithObject:dateDesc];
    

    
    
}

-(void)downloadCalendar{
    
    PFQuery* programQuery = [PFQuery queryWithClassName:@"ProgramsList"];
    NSArray* programsList = [programQuery findObjects];
    for (int i = 0; i < [programsList count]; i++){
        if ([[[programsList objectAtIndex:i] objectForKey:@"Name"] isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"userProgram"]]){
            currentProgram = [programsList objectAtIndex:i];
        }
    }
    
    NSString* calendarGroupTitle = [currentProgram objectForKey:@"Calendar"];
    
    PFQuery* calendarQuery = [PFQuery queryWithClassName:calendarGroupTitle];
    [calendarQuery orderByAscending:@"StartDate"];
    [calendarQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (!events) {
                events = [NSMutableArray new];
            }
            
            [events addObjectsFromArray:objects];
            [self doCalendar];
            
               
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    PFQuery* uniCalendarQuery = [PFQuery queryWithClassName:@"UniversalCalendar"];
    [uniCalendarQuery orderByAscending:@"StartDate"];
    [uniCalendarQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (!events) {
                events = [NSMutableArray new];
            }
            [events addObjectsFromArray:objects];
            [self doCalendar];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PFObject* calendarObject;
    switch ([indexPath section]) {
        case 0:
            calendarObject = [eventsToday objectAtIndex:indexPath.row];
            break;
            
        case 1:
            calendarObject = [eventsWeek objectAtIndex:indexPath.row];
            break;
            
        case 2:
            calendarObject = [eventsLater objectAtIndex:indexPath.row];
            break;
            
            
        default:
            break;
            
    }
    
    NSString* alertTitle = [calendarObject objectForKey:@"Name"];
    NSString* alertMessage = [calendarObject objectForKey:@"Description"];
    UIAlertView* infoAlert = [[UIAlertView alloc]initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [infoAlert show];
    
}

-(void)reloadPressed{
    [self downloadCalendar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
 //   NSString *searchTerm = self.searches[section];
    switch (section) {
        case 0:
            return [eventsToday count];
            break;
            
        case 1:
            return [eventsWeek count];
            break;
        
        case 2:
            return [eventsLater count];
            break;
            

            
        default:
            break;
    }
    
    return eventCount;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 3;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell* returnCell = [[UICollectionViewCell alloc]init];
    
    NSDateFormatter *stringFormatter = [[NSDateFormatter alloc] init];
    [stringFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    [stringFormatter setLocale:[NSLocale currentLocale]];
    
    
    switch (indexPath.section) {
        case 0: {
            
            UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"eventCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor redColor];
            UILabel* titleLabel = (UILabel*)[cell viewWithTag:2];
            
            
            //    HH:mm a EEE, dd MMM YYYY
            UILabel* dateLabel = (UILabel*)[cell viewWithTag:3];
            NSString* dateString;
            id date = [[eventsToday objectAtIndex:[indexPath row] ]objectForKey:@"StartDate"];
            
            [stringFormatter setDateFormat:@"h:mm a"];
            dateString = [stringFormatter stringFromDate:date];
            [dateLabel setText:dateString];
            [titleLabel setText:[[eventsToday objectAtIndex:[indexPath row] ]objectForKey:@"Name"]];
           
            

            
            
            returnCell = nil;
            returnCell = cell;
            
            
            
        
        }
            break;
            
        case 1:
        {
            
            UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"eventOtherCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor redColor];
            UILabel* titleLabel = (UILabel*)[cell viewWithTag:2];

            
            //    HH:mm a EEE, dd MMM YYYY
            UILabel* dateLabel = (UILabel*)[cell viewWithTag:3];
            PFObject* currentObject = [eventsWeek objectAtIndex:indexPath.row];
            id date = [currentObject objectForKey:@"StartDate"];
            
            //            dateString = [stringFormatter stringFromDate:date];
            //            [dateLabel setText:dateString];
            [titleLabel setText:[currentObject objectForKey:@"Name"]];
            
            [stringFormatter setDateFormat:@"MMM"];
            NSString* monthString = [stringFormatter stringFromDate:date];
            UILabel* monthLabel = (UILabel*)[cell viewWithTag:6];
            [monthLabel setText:monthString];
            
            [stringFormatter setDateFormat:@"dd"];
            NSString* numberDayString = [stringFormatter stringFromDate:date];
            UILabel* numberDayLabel = (UILabel*)[cell viewWithTag:4];
            [numberDayLabel setText:numberDayString];

            [stringFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
            [stringFormatter setDateFormat:@"h:mm a"];
            [stringFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
            NSString* timeString = [stringFormatter stringFromDate:date];
            UILabel* timeLabel = (UILabel*)[cell viewWithTag:5];
            [timeLabel setText:timeString];
            
            [stringFormatter setDateFormat:@"EEEE"];
            NSString* dayString = [stringFormatter stringFromDate:date];
            UILabel* dayLabel = (UILabel*)[cell viewWithTag:7];
            [dayLabel setText:dayString];
            
            returnCell = nil;
            returnCell = cell;
            
        }

            break;
            
        case 2:
        {
            
            UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"eventOtherCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor redColor];
            UILabel* titleLabel = (UILabel*)[cell viewWithTag:2];
            
            int x = [indexPath row];

            //    HH:mm a EEE, dd MMM YYYY
            UILabel* dateLabel = (UILabel*)[cell viewWithTag:3];
            PFObject* currentObject = [eventsLater objectAtIndex:indexPath.row];
            id date = [currentObject objectForKey:@"StartDate"];
            
//            dateString = [stringFormatter stringFromDate:date];
//            [dateLabel setText:dateString];
            [titleLabel setText:[currentObject objectForKey:@"Name"]];
            
            [stringFormatter setDateFormat:@"MMM"];
            NSString* monthString = [stringFormatter stringFromDate:date];
            UILabel* monthLabel = (UILabel*)[cell viewWithTag:6];
            [monthLabel setText:monthString];
            
            [stringFormatter setDateFormat:@"dd"];
            NSString* numberDayString = [stringFormatter stringFromDate:date];
            UILabel* numberDayLabel = (UILabel*)[cell viewWithTag:4];
            [numberDayLabel setText:numberDayString];
            
            [stringFormatter setDateFormat:@"h:mm a"];
            NSString* timeString = [stringFormatter stringFromDate:date];
            UILabel* timeLabel = (UILabel*)[cell viewWithTag:5];
            [timeLabel setText:timeString];

            [stringFormatter setDateFormat:@"EEEE"];
            NSString* dayString = [stringFormatter stringFromDate:date];
            UILabel* dayLabel = (UILabel*)[cell viewWithTag:7];
            [dayLabel setText:dayString];

            returnCell = nil;
            returnCell = cell;
            
        }
            
            break;
            
    }

    
 /*   UILabel* dateLabel = (UILabel*)[cell viewWithTag:3];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm a EEE, dd MMM YYYY"];
    //Optionally for time zone converstions
//    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSString *stringFromDate = [formatter stringFromDate:[[events objectAtIndex:[indexPath row] ]objectForKey:@"Date"]];

    [titleLabel setText:stringFromDate];*/

    return returnCell;
}
// 4
- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView* myView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];

    UILabel* sectionTitle = (UILabel*)[myView viewWithTag:1];
    switch (indexPath.section) {
        case 0:
            sectionTitle.text = @"Today's Events:";
            if (![eventsToday count]){
                sectionTitle.text = @"Nothing today";
            }
            break;
            
        case 1:
            sectionTitle.text = @"This Week's Events:";
            if (![eventsWeek count]){
                sectionTitle.text = @"There isn't anything else this week";
            }

            break;
            
        case 2:
            sectionTitle.text = @"Later Events:";
            if (![eventsLater count]){
                sectionTitle.text = @"Later Events: There isn't anything for a while";
            }

            break;

    }
    
 return myView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize returnSize;
    
    switch (indexPath.section) {
        case 0:
            returnSize = CGSizeMake(300, 60);
            
            break;
            
        case 1:
  
            returnSize = CGSizeMake(152, 70);

            
            break;
            
        case 2:
            returnSize = CGSizeMake(160, 82);


            break;
            }

    return returnSize;
}

@end
