//
//  HTAnnotation.m
//  MapKitDemo
//
//  Created by Christoph on 9/9/14.
//  Copyright (c) 2014 Hermiteer, LLC. All rights reserved.
//

#import "HTRouteEvent.h"

//------------------------------------------------------------------------------

@implementation HTRouteEvent

// Synthesize properties declared in protocol
@synthesize coordinate, boundingMapRect;

//------------------------------------------------------------------------------

- (instancetype) initWithLocation:(CLLocation*)location
{
    self = [super init];
    if (self) {
        _location = location;
    }
    return self;
}

//------------------------------------------------------------------------------

- (CLLocationCoordinate2D) coordinate
{
    return self.location.coordinate;
}

//------------------------------------------------------------------------------

@end
