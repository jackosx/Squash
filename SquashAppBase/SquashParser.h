//
//  SquashParser.h
//  SquashAlley
//
//  Created by Jack O'Shea on 8/31/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SquashParser : NSObject <NSXMLParserDelegate> {
    NSString* schoolTest;
    NSString* announcementTest;
    
    NSString* currentElement;
    
    NSMutableString* textString;
    
    NSXMLParser* myParser;
    
    NSMutableArray* schools;
    NSMutableArray* announcements;
    NSMutableDictionary* tempAnn;
    
    NSMutableDictionary* parsedData;
    
    //Dictionaries to be reused. Add them to parsedData then set to nil and repeat.
    //From Largest to Smallest:

    NSMutableArray* Announcements;
    NSMutableDictionary* Announcement;
    
    
    NSMutableDictionary* Schools;
    NSMutableDictionary* School;
    NSMutableDictionary* Schedule;
    NSMutableArray* Events;
    NSMutableDictionary* Event;
    NSMutableDictionary* Ladder;
    NSMutableArray* Players;
    NSMutableDictionary* Player;
    

}

-(NSDictionary*)doParsing;
-(NSDictionary*)getLadder;
-(NSDictionary*)getSchedule;
-(NSArray*)getUnivEvents;
-(NSDate*)getDate:(NSString*)theString;

@property (nonatomic, retain) NSMutableDictionary* parsedData;


@property (nonatomic, retain) NSMutableDictionary* Schools;
@property (nonatomic, retain) NSMutableDictionary* School;
@property (nonatomic, retain) NSMutableDictionary* Schedule;
@property (nonatomic, retain) NSMutableDictionary* Events;
@property (nonatomic, retain) NSMutableDictionary* Event;
@property (nonatomic, retain) NSMutableDictionary* Ladder;
@property (nonatomic, retain) NSMutableDictionary* Players;
@property (nonatomic, retain) NSMutableDictionary* Player;


@property (nonatomic, retain) NSMutableArray* Announcements;
@property (nonatomic, retain) NSMutableDictionary* Announcement;


@end
