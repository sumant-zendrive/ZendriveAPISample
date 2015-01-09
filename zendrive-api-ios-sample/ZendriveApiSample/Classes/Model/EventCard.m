//
//  EventCard.m
//  
//
//  Created by Gati Antal Arnold on 11/11/13.
//  Copyright (c) 2013 Inner Circle Technologies. All rights reserved.
//

#import "EventCard.h"
#import "ParsingUtility.h"

#define kPostedSpeedLimitKey                @"posted_speed_limit"
#define kSpeedLimitKey                      @"speed_limit_mph"
#define kUserSpeedKey                       @"user_speed_mph"

static NSString *kHardBrakingTitle = @"Hard Braking";
static NSString *kPhoneUsageTitle = @"Phone Usage";
static NSString *kSpeedingTitle = @"Speeding";
static NSString *kAccelerationTitle = @"Rapid Acceleration";

@implementation EventCard

- (instancetype)initWithApiResponse:(NSDictionary *)eventDictionary
{
    self = [super init];
    if (self) {
        _startTime = [ParsingUtility dateFromDateString:eventDictionary[@"start_time"]];
        _endTime = [ParsingUtility dateFromDateString:eventDictionary[@"end_time"]];
        _eventType = [ParsingUtility getEventCardTypeFromEventTypeString:eventDictionary[@"event_type"]];

        NSString *latitudeStartString = eventDictionary[@"latitude_start"];
        NSString *longitudeStartString = eventDictionary[@"longitude_start"];
        CLLocationDegrees latitudeStart = latitudeStartString.doubleValue;
        CLLocationDegrees longitudeStart = longitudeStartString.doubleValue;
        _startLocation = [[CLLocation alloc] initWithLatitude:latitudeStart longitude:longitudeStart];

        NSString *latitudeEndString = eventDictionary[@"latitude_end"];
        NSString *longitudeEndString = eventDictionary[@"longitude_end"];
        CLLocationDegrees latitudeEnd = latitudeEndString.doubleValue;
        CLLocationDegrees longitudeEnd = longitudeEndString.doubleValue;
        _endLocation = [[CLLocation alloc] initWithLatitude:latitudeEnd longitude:longitudeEnd];
        _eventData = [eventDictionary mutableCopy];
    }
    return self;
}

- (NSString *)getViolationString {
    NSString *violationString = @"";
    if (self.eventType == EventCardTypeSpeeding &&
        self.eventData[kPostedSpeedLimitKey] != nil) {
        NSDictionary *postedSpeedLimitDictionary = self.eventData[kPostedSpeedLimitKey];
        NSString *speedLimit = postedSpeedLimitDictionary[kSpeedLimitKey];
        NSString *userSpeed = postedSpeedLimitDictionary[kUserSpeedKey];

        if (speedLimit && userSpeed) {
            violationString = [NSString stringWithFormat:@"%@mph in %@mph area", userSpeed, speedLimit];
        }
    }

    return violationString;
}

+ (UIImage *)imageForEventCardType:(EventCardType)eventCardType {
    switch (eventCardType) {
        case EventCardTypeAggressiveAcceleration:
            return [UIImage imageNamed:@"acceleration"];

        case EventCardTypeHardBrake:
            return [UIImage imageNamed:@"hardbrake"];

        case EventCardTypePhoneUse:
            return [UIImage imageNamed:@"phone_use"];

        case EventCardTypeSpeeding:
            return [UIImage imageNamed:@"over_speeding"];

        default:
            // Don't display these
            return nil;
    }
}

+ (NSString *)titleForEventCardType:(EventCardType)type {
    NSString *title = @"";
    switch (type) {
        case EventCardTypeAggressiveAcceleration:
            title = kAccelerationTitle;
            break;
        case EventCardTypeHardBrake:
            title = kHardBrakingTitle;
            break;
        case EventCardTypePhoneUse:
            title = kPhoneUsageTitle;
            break;
        case EventCardTypeSpeeding:
            title = kSpeedingTitle;
            break;
        default:
            break;
    }
    return title;
}

@end
