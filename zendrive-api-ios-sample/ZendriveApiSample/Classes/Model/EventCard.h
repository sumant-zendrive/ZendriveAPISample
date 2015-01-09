//
//  EventCard.h
//
//
//  Created by Gati Antal Arnold on 11/11/13.
//  Copyright (c) 2013 Inner Circle Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    EventCardTypeAggressiveAcceleration,
    EventCardTypeHardBrake,
    EventCardTypePhoneUse,
    EventCardTypeSpeeding,
    EventCardTypeInvalid
} EventCardType;

@interface EventCard : NSObject

@property (nonatomic) NSDate                    *startTime;
@property (nonatomic) NSDate                    *endTime;
@property (nonatomic) EventCardType             eventType;
@property (nonatomic) CLLocation                *startLocation;
@property (nonatomic) CLLocation                *endLocation;
@property (nonatomic) NSMutableDictionary       *eventData;

- (instancetype)initWithApiResponse:(NSDictionary *)eventDictionary;
- (NSString *)getViolationString;
+ (UIImage *)imageForEventCardType:(EventCardType)eventCardType;
+ (NSString *)titleForEventCardType:(EventCardType)type;
@end
