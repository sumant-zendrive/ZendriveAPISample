//
//  TripCard.m
//  
//
//  Created by Gati Antal Arnold on 11/11/13.
//  Copyright (c) 2013 Inner Circle Technologies. All rights reserved.
//

#import "TripCard.h"
#import "EventCard.h"
#import "GpsPoint.h"

#import "ZendriveScores.h"
#import "ParsingUtility.h"

@implementation TripCard

- (instancetype)initWithApiResponse:(NSDictionary *)tripDictionary{
    self = [super init];
    if (self) {
        _tripId = [tripDictionary[@"trip_id"] description];

        NSDictionary *infoDictionary = tripDictionary[@"info"];
        NSString *distanceString = infoDictionary[@"distance_km"];
        _distance = (distanceString.doubleValue)*1000;
        _driveTime = [ParsingUtility
                      durationInSecondsFromDurationString:infoDictionary[@"drive_time_hours"]];
        _startDate = [ParsingUtility dateFromDateString:infoDictionary[@"start_time"]];
        _endDate = [ParsingUtility dateFromDateString:infoDictionary[@"end_time"]];
        _trackingId = infoDictionary[@"tracking_id"];
        if ([@"NA" isEqualToString:_trackingId]) {
            _trackingId = nil;
        }
        _sessionId = infoDictionary[@"session_id"];

        _scores = [[ZendriveScores alloc] initWithAPIResponse:tripDictionary[@"score"]];
    }
    return self;
}

- (void)addDetailsUsingApiResponse:(NSDictionary *)tripDetailsDictionary {
    if (self.scores.areValidScores) {
        // Events are populated with score calculation, so they wouldn't be valid unless we
        // have valid scores
        NSArray *eventDictionaries = tripDetailsDictionary[@"events"];
        NSMutableArray *eventsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *eventDictionary in eventDictionaries) {
            EventCard *eventCard = [[EventCard alloc] initWithApiResponse:eventDictionary];
            [eventsArray addObject:eventCard];
        }

        self.events = eventsArray;
    }

    // Parse simple path
    NSMutableArray *gpsPointsArray = [[NSMutableArray alloc] init];
    NSArray *simplePathPointDictionariesArray = tripDetailsDictionary[@"simple_path"];
    for (NSDictionary *gpsPointDictionary in simplePathPointDictionariesArray) {
        GpsPoint *gpsPoint = [[GpsPoint alloc] initWithApiResponse:gpsPointDictionary];
        [gpsPointsArray addObject:gpsPoint];
    }
    self.simplePath = gpsPointsArray;
}

@end