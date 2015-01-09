//
//  GpsPoint.h
//  ZendriveApiSample
//
//  Created by Yogesh Maheshwari on 08/01/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GpsPoint : NSObject

@property (nonatomic) CLLocation        *location;
@property (nonatomic) long long         timeMillisecond;
@property (nonatomic) NSDate            *timestamp;

- (instancetype)initWithApiResponse:(NSDictionary *)gpsDictionary;
@end
