//
//  SquashLadderGetter.h
//  SquashAppBase
//
//  Created by Jack O'Shea on 11/14/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SquashLadderGetter : NSObject {
    BOOL blockFinished;
}

-(NSArray*)getLadderForGroup:(NSString*)ladderGroup;


@end
