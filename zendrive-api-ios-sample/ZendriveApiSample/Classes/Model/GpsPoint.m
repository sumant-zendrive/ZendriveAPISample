//
//  GpsPoint.m
//  ZendriveApiSample
//
//  Created by Yogesh Maheshwari on 08/01/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import "GpsPoint.h"
#import "ParsingUtility.h"

@implementation GpsPoint

- (instancetype)initWithApiResponse:(NSDictionary *)gpsDictionary
{
    self = [super init];
    if (self) {
        NSString *latitudeString = gpsDictionary[@"latitude"];
        NSString *longitudeString = gpsDictionary[@"longitude"];
        CLLocationDegrees latitude = latitudeString.doubleValue;
        CLLocationDegrees longitude = longitudeString.doubleValue;
        _location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];

        NSString *timeMillisString = [gpsDictionary[@"time_millis"] description];
        _timeMillisecond = timeMillisString.longLongValue;
        _timestamp = [ParsingUtility dateFromDateString:gpsDictionary[@"timestamp"]];
    }
    return self;
}

@end
