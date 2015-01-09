//
//  HTAnnotation.h
//  MapKitDemo
//
//  Created by Christoph on 9/9/14.
//  Copyright (c) 2014 Hermiteer, LLC. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "EventCard.h"


//------------------------------------------------------------------------------
// This class is used to hold any point that is displayed on map
// Two type of points -
// 1. To display path on map
// 2. To display trip events on map
//------------------------------------------------------------------------------

@interface HTRouteEvent : NSObject <MKOverlay>

//------------------------------------------------------------------------------

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) CLLocation* location;

//------------------------------------------------------------------------------

@property (nonatomic) BOOL isStartLocation;
@property (nonatomic) BOOL isEndLocation;

//------------------------------------------------------------------------------

// If eventCard is nil then this HTRouteEvent only holds path point
@property (nonatomic, strong) EventCard *eventCard;

//------------------------------------------------------------------------------

- (instancetype) initWithLocation:(CLLocation*)location;

//------------------------------------------------------------------------------

@end
