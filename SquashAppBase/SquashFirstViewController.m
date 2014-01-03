//
//  SquashFirstViewController.m
//  SquashAlley
//
//  Created by Jack O'Shea on 7/13/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import "SquashFirstViewController.h"

@interface SquashFirstViewController ()

@end

@implementation SquashFirstViewController



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    PFObject* currentObject = [newsArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    UILabel* nameLabel = [cell viewWithTag:1];
    NSString* nameString = [currentObject objectForKey:@"Title"];
    [nameLabel setText:nameString];
    
    UILabel* dateLabel = [cell viewWithTag:2];
    NSDate* writtenDate = [currentObject updatedAt];
    NSString* dateString = [self getDateString:writtenDate];
    [dateLabel setText:dateString];
    
    UILabel* prevLabel = [cell viewWithTag:3];
    NSString* prevString = [currentObject objectForKey:@"Body"];
    [prevLabel setText:prevString];
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self setArticleTo:indexPath.row];

}


-(void)setArticleTo:(int)objectIndex{
    PFObject* currentObject = [newsArray objectAtIndex:objectIndex];
    articleTitleView.text = [currentObject objectForKey:@"Title"];
    articleDateView.text = [self getDateString:[currentObject updatedAt]];
    articleBodyView.text = [currentObject objectForKey:@"Body"];
    if ([currentObject objectForKey:@"Picture"]) {
        [[currentObject objectForKey:@"Picture"]getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            [articleImage setImage:[UIImage imageWithData:imageData]];
                }
            }];
        }
    

}

-(NSString*)getDateString:(NSDate *)theDate{
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"h:mm a EEEE, MMMM dd yyyy"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    NSString* theString = [formatter stringFromDate:theDate];
    
    NSLog(@"THE DATE WRITTEN IS %@",theString);
    
    return theString;
}




- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    return [newsArray count];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    articleImage.center = CGPointMake(articleImage.center.x, articleTitleView.center.y);
}

-(void)reloadPressed{
    PFQuery* newsQuery = [PFQuery queryWithClassName:@"GeneralNews"];
    [newsQuery orderByAscending:@"updatedAt"];
    [newsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            newsArray = nil;
            newsArray = objects;
            [tableViewRef reloadData];
            
            [self setArticleTo:0];
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    

}

- (void)viewDidAppear:(BOOL)animated{
//    [self firstTimeSetup];
	// Do any additional setup after loading the view, typically from a nib.
   // [defaults setObject:nil forKey:@"hasOpened"];
    newsArray = [NSArray new];
    
    defaults = [[NSUserDefaults alloc]init];
    if (![defaults objectForKey:@"hasOpened"]){
        [defaults setObject:@"hasOpened" forKey:@"hasOpened"];
        [self firstTimeSetup];
        NSLog(@"FirstTime Opening");
    }
    
    PFQuery* newsQuery = [PFQuery queryWithClassName:@"GeneralNews"];
    [newsQuery orderByAscending:@"updatedAt"];
    [newsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            newsArray = nil;
            newsArray = objects;
            [tableViewRef reloadData];
            
            [self setArticleTo:0];

            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    

    
    [tableViewRef reloadData];
    

}

-(void)firstTimeSetup{


}


-(void)donePressed{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
