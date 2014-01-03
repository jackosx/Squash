//
//  SquashLadderGetter.m
//  SquashAppBase
//
//  Created by Jack O'Shea on 11/14/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import "SquashLadderGetter.h"

@implementation SquashLadderGetter

-(NSArray*)getLadderForGroup:(NSString*)ladderGroup{
    NSString* testLadderGroup = @"VarsityBoys";
    
    
    NSMutableArray* returnLadder = [NSMutableArray new];
    
    PFQuery* ladderQuery = [PFQuery queryWithClassName:testLadderGroup];
    [ladderQuery orderByAscending:@"Rank"];
    [ladderQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            NSLog(@"Successfully retrieved %d PLAYERS AND IT WORKED.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                
                NSLog(@"ADDING PLAYER");
                [returnLadder addObject:object];
            
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    return [ladderQuery findObjects];
}




@end
