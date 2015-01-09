//
//  ParsingUtility.h
//  ZendriveApiSample
//
//  Created by Yogesh Maheshwari on 07/01/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventCard.h"

@interface ParsingUtility : NSObject

+ (NSDate *) dateFromDateString:(NSString *)dateString;
+ (NSTimeInterval) durationInSecondsFromDurationString:(NSString *)durationString;
+ (EventCardType) getEventCardTypeFromEventTypeString:(NSString *)eventTypeString;
@end
