//
//  ZendriveScores.h
//  
//
//  Created by Manish Sachdev on 10/09/14.
//  Copyright (c) 2014 Zendrive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZendriveScores : NSObject

- (instancetype) initWithAPIResponse:(NSDictionary *)dictionary;

@property (readonly) int fuelEfficiencyScore;
@property (readonly) int focusScore;
@property (readonly) int cautiousScore;
@property (readonly) int controlScore;
@property (readonly) int zendriveScore;

- (BOOL)areValidScores;
@end
