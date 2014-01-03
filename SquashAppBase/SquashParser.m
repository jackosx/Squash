//
//  SquashParser.m
//  SquashAlley
//
//  Created by Jack O'Shea on 8/31/13.
//  Copyright (c) 2013 Jack O'Shea. All rights reserved.
//

#import "SquashParser.h"

@implementation SquashParser

- (id)initWithGoal:(NSString*)goal
{
    self = [super init];
    if (self) {
        // Custom initialization
        parsedData = [NSMutableDictionary new];
        
    }
    
    return self;
}



-(NSDictionary*)doParsing{


    NSString *address =@"http://www.squashalley.com/SquashData.xml";
    NSURL* otherURL = [[NSURL alloc]initWithString:address];
    
    
    
    myParser = [[NSXMLParser alloc]initWithContentsOfURL:otherURL];
    
    
    textString = [[NSMutableString alloc]init];
  //  announcements = [[NSMutableArray alloc]init];
    
    parsedData = nil;
    parsedData = [NSMutableDictionary new];

    
    schools = [NSMutableArray new];
    
    [myParser setDelegate:self];
    [myParser parse];
    
//    NSLog(@"There are %d schools (in memory)",[[parsedData objectForKey:@"Schools"] count]);
    
    
    parsedData = nil;
    parsedData = [NSMutableDictionary new];

    
    return parsedData;
}

-(NSDictionary*)getLadder{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* userSchool = [defaults objectForKey:@"userSchool"];
    
    NSLog(@"Schoolname is %@",userSchool);
    
    NSDictionary* firstDict = [defaults objectForKey:@"storedData"];
    NSDictionary* secondDict = [firstDict objectForKey:@"Schools"];
    NSDictionary* thirdDict = [secondDict objectForKey:userSchool];
    NSDictionary* fourthDict = [thirdDict objectForKey:@"Ladder"];
   // NSArray* fifthDict = [fourthDict objectForKey:@"Players"];

    
                               return fourthDict;
}

-(NSDictionary*)getSchedule{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* userSchool = [defaults objectForKey:@"userSchool"];
    NSLog(userSchool);
    
    NSDictionary* firstDict = [defaults objectForKey:@"storedData"];
    NSDictionary* secondDict = [firstDict objectForKey:@"Schools"];
    NSDictionary* thirdDict = [secondDict objectForKey:userSchool];
    NSDictionary* fourthDict = [thirdDict objectForKey:@"Schedule"];
    // NSArray* fifthDict = [fourthDict objectForKey:@"Players"];
    
    
    return fourthDict;
}
-(NSArray*)getUnivEvents{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* firstDict = [defaults objectForKey:@"storedData"];
    return [firstDict objectForKey:@"UniversalEvents"];
}

-(NSDate*)getDate:(NSString *)theString{
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"hh:mm a MMMM dd yyyy"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    NSDate* theDate = [formatter dateFromString:theString];
    
    
    NSDateFormatter *stringFormatter = [[NSDateFormatter alloc] init];
    [stringFormatter setDateFormat:@"yyyy"];
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    NSString *stringFromDate = [stringFormatter stringFromDate:theDate];
    
    NSLog(@"The Year is %@",stringFromDate);
    
    
    return theDate;
}


- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
	//NSLog(@"Parsing elementName: %@ namespace: %@ qName: %@ ", elementName, namespaceURI, qualifiedName);
    
    if ([elementName isEqualToString:@"Schools"]) {
//        NSLog(@"New School list Created");

      //  currentElement = elementName;
        Schools = nil;
        Schools = [NSMutableDictionary new];        
    }
    
    if ([elementName isEqualToString:@"School"]) {
        School = nil;
        School = [NSMutableDictionary new];
        
//        NSLog(@"New SChool Created");

    }
    
    if ([elementName isEqualToString:@"Player"]) {
        Player = nil;        
        Player = [NSMutableDictionary new];
//        NSLog(@"New Player Created");
    }

    if ([elementName isEqualToString:@"Players"]) {
        Players = nil;
        Players = [NSMutableArray new];
//        NSLog(@"New Player list Created");
    }

    
    if ([elementName isEqualToString:@"Ladder"]) {
        Ladder = nil;
        Ladder = [NSMutableDictionary new];
//        NSLog(@"New Ladder Created");

    }

    if ([elementName isEqualToString:@"Schedule"]) {
        Schedule = nil;
        Schedule = [NSMutableDictionary new];
    }

    if ([elementName isEqualToString:@"Events"]) {
        Events = nil;
        Events = [NSMutableArray new];
    }

    if ([elementName isEqualToString:@"UniversalEvents"]) {
        Events = nil;
        Events = [NSMutableArray new];
    }

    
    if ([elementName isEqualToString:@"Event"]) {
        Event = nil;
        Event = [NSMutableDictionary new];
    }

    if ([elementName isEqualToString:@"Announcement"]) {
        Announcement = nil;
        Announcement = [NSMutableDictionary new];
    }

    
    if ([elementName isEqualToString:@"Announcements"]) {
        Announcements = nil;
        Announcements = [NSMutableArray new];
    
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    textString = nil;
    textString = [NSMutableString new];
    [textString setString:string];
    //textString = string;
    
    
}



- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"Data"]) {
        // We reached the end of the XML document
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:parsedData forKey:@"storedData"];

        return;
    }
    
    
//    DEBUG DEBUG DEBUG
//    NSLog(@"Finished %@", elementName);
//    NSLog(@"Just read %@ ",textString);
    
    //MISC.
    if ([elementName isEqualToString:@"Schools"]) {
//        NSLog(@"There are %d schools",[Schools count]);
        [parsedData setObject:Schools forKey:elementName];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:parsedData forKey:@"storedData"];

    }
    if ([elementName isEqualToString:@"Announcements"]) {
        [parsedData setObject:Announcements forKey:elementName];
    }
    
    
    
    //SCHOOL
    if ([elementName isEqualToString:@"SchoolName"]){
        [School setObject:textString forKey:elementName];
    }
    if ([elementName isEqualToString:@"Schedule"]){
        [School setObject:Schedule forKey:elementName];
    }
    if ([elementName isEqualToString:@"Ladder"]){
        [School setObject:Ladder forKey:elementName];
    }
    
    //FINISH SCHOOL BEFORE RESET
    if ([elementName isEqualToString:@"School"]){
        [Schools setObject:School forKey:[School objectForKey:@"SchoolName"]];
        School = nil;
    }

    //LADDER
    if ([elementName isEqualToString:@"Players"]){
        [Ladder setObject:Players forKey:elementName];
    }
    if ([elementName isEqualToString:@"LadderInfo"]){
        [Ladder setObject:textString forKey:elementName];
    }

//    ANNOUNCEMENTS
    if ([elementName isEqualToString:@"Title"]) {
        [Announcement setObject:textString forKey:elementName];
    }
    if ([elementName isEqualToString:@"Text"]) {
        [Announcement setObject:textString forKey:elementName];
    }
    if ([elementName isEqualToString:@"Announcement"]) {
        
        [Announcements addObject:Announcement];
        Announcement = nil;
    }
    
   
    //PLAYER
    if ([elementName isEqualToString:@"Name"]){
        if (!Player){
            NSLog(@"No player yet");
            Player = [[NSMutableDictionary alloc]init];

        }
        [Player setObject:textString forKey:elementName];
        if (!Player){
            NSLog(@"No player yet");
        }

        
    }
    if ([elementName isEqualToString:@"Score"]){
        [Player setObject:[NSNumber numberWithInt:[textString intValue]] forKey:elementName];
        
    }
    if ([elementName isEqualToString:@"PictureURL"]){
        [Player setObject:textString forKey:elementName];
    }
    if ([elementName isEqualToString:@"Name"]){
        [Player setObject:textString forKey:elementName];
    }
    if ([elementName isEqualToString:@"Other"]){
        [Player setObject:textString forKey:elementName];
    }
    
    //FINISH PLAYER BEFORE RESET
    if ([elementName isEqualToString:@"Player"]){
        [Players addObject:Player];
        Player = nil;
//        NSLog(@"There are %d players",[Players count]);

    }

    //EVENT
 
    if ([elementName isEqualToString:@"ETitle"]){
        [Event setObject:textString forKey:elementName];
    }
    if ([elementName isEqualToString:@"EDetail"]){
        [Event setObject:textString forKey:elementName];
    }
    if ([elementName isEqualToString:@"Date"]){
        [Event setObject:[self getDate:textString] forKey:elementName];
//        [Event setObject:textString forKey:elementName];

    }
    if ([elementName isEqualToString:@"NotificationData"]){
        [Event setObject:textString forKey:elementName];
    }
    
    //FINISH EVENT BEFORE RESET
    if ([elementName isEqualToString:@"Event"]){
    
        [Events addObject:Event];
        
        
        Event = nil;
    }
    
    if ([elementName isEqualToString:@"Events"]) {
        [Schedule setObject:Events forKey:elementName];
    }
    
    if ([elementName isEqualToString:@"UniversalEvents"]) {
        [parsedData setObject:Events forKey:elementName];
    }

    
    
}


@end
