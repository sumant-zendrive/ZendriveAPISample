//
//  ZendriveAPI.m
//  ZendriveApiSample
//
//  Created by Yogesh Maheshwari on 07/01/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import "ZendriveAPI.h"

#import "GeneralConstants.h"
#import "HMConstants.h"
#import "NSObject+BlockAdditions.h"

#import "TripCard.h"

static NSString *kDriverTripsUrlFormat = @"https://api.zendrive.com/v1/driver/%@/trips?apikey=%@&fields=info,score&limit=50";
static NSString *kTripDetailsUrlFormat =
@"https://api.zendrive.com/v1/driver/%@/trip/%@?apikey=%@&fields=simple_path,events";

static NSString *kAppErrorDomain = @"com.zendrive.ZendriveApiSample";
static NSString *kUnknownErrorDescription = @"Unknown error!!";

@implementation ZendriveAPI

+ (instancetype) sharedInstance {
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (void)fetchTripsForUser:(NSString *)userId completion:(void (^)(NSArray *, NSError *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *requestUrl = [NSString stringWithFormat:
                                kDriverTripsUrlFormat, userId, kApplicationKey];

        NSMutableURLRequest *request = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:requestUrl]];

        NSHTTPURLResponse *responseCode = nil;
        NSError *error;
        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request
                                                      returningResponse:&responseCode
                                                                  error:&error];
        if([responseCode statusCode] != 200 || oResponseData == nil){
            if (!error) {
                error =
                [[NSError alloc] initWithDomain:kAppErrorDomain code:responseCode.statusCode
                                       userInfo:@{NSLocalizedDescriptionKey:
                                                      kUnknownErrorDescription}];
            }

            if (completion) {
                completion(nil, error);
            }
            return;
        }

        NSDictionary *response = [NSJSONSerialization
                                  JSONObjectWithData:oResponseData
                                  options:NSJSONReadingMutableContainers error:&error];

        NSMutableArray *trips = [[NSMutableArray alloc] init];
        for (NSDictionary *tripDict in response[@"trips"]) {
            TripCard *trip = [[TripCard alloc] initWithApiResponse:tripDict];
            if (trip) {
                [trips addObject:trip];
            }
        }

        [self performBlockOnMainThread:^{
            completion(trips, error);
        }];
    });
}

- (void)fetchDetailsForTrip:(TripCard *)trip user:(NSString *)userId completion:
(void (^)(TripCard *, NSError *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *requestUrl = [NSString stringWithFormat:
                                kTripDetailsUrlFormat, userId, trip.tripId, kApplicationKey];

        NSMutableURLRequest *request = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:requestUrl]];

        NSHTTPURLResponse *responseCode = nil;
        NSError *error;
        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request
                                                      returningResponse:&responseCode
                                                                  error:&error];
        if([responseCode statusCode] != 200 || oResponseData == nil) {
            if (!error) {
                error =
                [[NSError alloc] initWithDomain:kAppErrorDomain
                                           code:responseCode.statusCode
                                       userInfo:@{NSLocalizedDescriptionKey:
                                                      kUnknownErrorDescription}];
            }

            if (completion) {
                completion(nil, error);
            }
            return;
        }

        NSDictionary *response = [NSJSONSerialization
                                  JSONObjectWithData:oResponseData
                                  options:NSJSONReadingMutableContainers error:&error];
        [trip addDetailsUsingApiResponse:response];

        [self performBlockOnMainThread:^{
            completion(trip, error);
        }];
    });
}

@end
