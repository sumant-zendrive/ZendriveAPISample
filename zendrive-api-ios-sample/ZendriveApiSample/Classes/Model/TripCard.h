//
//  TripCard.h
//  
//
//  Created by Gati Antal Arnold on 11/11/13.
//  Copyright (c) 2013 Inner Circle Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZendriveScores;
@interface TripCard : NSObject

- (instancetype)initWithApiResponse:(NSDictionary *)tripDictionary;
- (void)addDetailsUsingApiResponse:(NSDictionary *)tripDetailsDictionary;

@property (nonatomic) NSString              *tripId;
@property (nonatomic) NSDate                *startDate;
@property (nonatomic) NSDate                *endDate;
@property (nonatomic) NSTimeInterval        driveTime    /* seconds */;
@property (nonatomic) double                distance     /* meters */;
@property (nonatomic) NSString              *trackingId;
@property (nonatomic) NSString              *sessionId;

@property (nonatomic) ZendriveScores        *scores;

@property (nonatomic) NSMutableArray        *simplePath;
@property (nonatomic) NSMutableArray        *events;
@end
