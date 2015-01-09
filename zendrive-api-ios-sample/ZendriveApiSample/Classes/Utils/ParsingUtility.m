//
//  ParsingUtility.m
//  ZendriveApiSample
//
//  Created by Yogesh Maheshwari on 07/01/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import "ParsingUtility.h"

@implementation ParsingUtility

+ (NSDate *) dateFromDateString:(NSString *)dateString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:sszzzz";
    NSDate *date = [df dateFromString:dateString];
    return date;
}

+ (NSTimeInterval)durationInSecondsFromDurationString:(NSString *)durationString {
    NSTimeInterval timeIntervel = -1;
    if (durationString.length > 0) {
        NSArray *hourMinuteArray = [durationString componentsSeparatedByString:@":"];
        int hours = 0, minutes = 0;

        if (hourMinuteArray.count > 1) {
            NSString *minutesString = hourMinuteArray[1];
            minutes = minutesString.intValue;
        }

        if (hourMinuteArray.count > 0) {
            NSString *hourString = hourMinuteArray[0];
            hours = hourString.intValue;
        }

        timeIntervel = (hours * 60 + minutes) * 60;
    }

    return timeIntervel;
}

+ (EventCardType) getEventCardTypeFromEventTypeString:(NSString *)eventTypeString {
    EventCardType eventCardType = EventCardTypeInvalid;
    if ([eventTypeString isEqualToString:@"OverSpeeding"]) {
        eventCardType = EventCardTypeSpeeding;
    }
    else if ([eventTypeString isEqualToString:@"PhoneUse"]) {
        eventCardType = EventCardTypePhoneUse;
    }
    else if ([eventTypeString isEqualToString:@"AggressiveAcceleration"]) {
        eventCardType = EventCardTypeAggressiveAcceleration;
    }
    else if ([eventTypeString isEqualToString:@"HardBrake"]) {
        eventCardType = EventCardTypeHardBrake;
    }

    return eventCardType;
}

@end
