//
//  ZendriveAPI.h
//  ZendriveApiSample
//
//  Created by Yogesh Maheshwari on 07/01/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TripCard;
@interface ZendriveAPI : NSObject

+ (instancetype) sharedInstance;

- (void) fetchTripsForUser:(NSString*)userId
                     completion:(void(^)(NSArray *trips, NSError *error))completion;

- (void) fetchDetailsForTrip:(TripCard *)trip user:(NSString *)userId
                      completion:(void (^)(TripCard *, NSError *))completion;

@end
