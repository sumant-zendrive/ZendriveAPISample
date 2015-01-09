//
//  ZendriveScores.m
//  
//
//  Created by Manish Sachdev on 10/09/14.
//  Copyright (c) 2014 Zendrive. All rights reserved.
//

#import "ZendriveScores.h"

// API Response key paths
static NSString *kAPIKeyPathZendriveScore = @"zendrive_score";
static NSString *kAPIKeyPathCautiousScore = @"cautious_score";
static NSString *kAPIKeyPathFuelEfficiencyScore = @"fuel_efficiency_score";
static NSString *kAPIKeyPathControlScore = @"control_score";
static NSString *kAPIKeyPathFocusedScore = @"focused_score";

@implementation ZendriveScores

- (instancetype) init {
    self = [super init];
    if (self) {
        _zendriveScore = -1;
        _cautiousScore = -1;
        _fuelEfficiencyScore = -1;
        _controlScore = -1;
        _focusScore = -1;
    }
    return self;
}

- (instancetype) initWithAPIResponse:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _zendriveScore = [[dictionary valueForKeyPath:kAPIKeyPathZendriveScore] intValue];
        _cautiousScore = [[dictionary valueForKeyPath:kAPIKeyPathCautiousScore] intValue];
        _fuelEfficiencyScore = [[dictionary valueForKeyPath:kAPIKeyPathFuelEfficiencyScore] intValue];

        id controlScore = [dictionary valueForKeyPath:kAPIKeyPathControlScore];
        if (controlScore != nil) {
            _controlScore = [controlScore intValue];
        }

        // This is a temp fix while zendriveScore is being populated in the backend
        if (_zendriveScore == -1) {
            _zendriveScore = (int)(0.288 * (float)_cautiousScore +
                                   0.403 * (float)_fuelEfficiencyScore +
                                   0.309 * (float)_controlScore);
        }

        id focusScore = [dictionary valueForKey:kAPIKeyPathFocusedScore];
        if (focusScore != nil) {
            _focusScore = [focusScore intValue];
        }
    }
    return self;
}

- (BOOL)areValidScores {
    return !(self.fuelEfficiencyScore == -1 ||
             self.focusScore == -1 ||
             self.cautiousScore == -1 ||
             self.controlScore == -1 ||
             self.zendriveScore == -1);
}

@end
