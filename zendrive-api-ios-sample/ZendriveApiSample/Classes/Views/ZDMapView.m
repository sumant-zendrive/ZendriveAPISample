//
//  ZDMapView.m
//  
//
//  Created by Yogesh Maheshwari on 10/09/14.
//  Copyright (c) 2014 Zendrive. All rights reserved.
//

#import "ZDMapView.h"
#import "GpsPoint.h"
#import "HTRouteEvent.h"
#import "UIColor+ZendriveApiSample.h"
#import "TripCard.h"

static double kHorizontalAccuracyThreshold = 2500;

@interface ZDMapView()<MKMapViewDelegate> {
    BOOL isZoomedIn;
}

//------------------------------------------------------------------------------

@property (nonatomic, strong) MKPolyline* polyline;

//------------------------------------------------------------------------------

@property (nonatomic, strong) NSMutableArray* routePointEvents;
@property (nonatomic, strong) NSMutableArray* tripEvents;
@property (nonatomic, strong) HTRouteEvent* startEvent;
@property (nonatomic, strong) HTRouteEvent* endEvent;

//------------------------------------------------------------------------------

@end

@implementation ZDMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initialize];
}

-(void)initialize{
    [super setDelegate:self];
    
    // array for current overlays
    self.routePointEvents = [NSMutableArray array];
    self.tripEvents = [NSMutableArray array];
}

-(void)setTripCard:(TripCard *)tripCard andEventCardsArray:(NSArray *)eventCardsArray{
    
    self.showsUserLocation = NO;
    self.userTrackingMode = MKUserTrackingModeNone;

    // Clear route points
    [self.routePointEvents removeAllObjects];
    [self.tripEvents removeAllObjects];
    [self removeAnnotations:self.annotations];

    // Draw path with start and end points
    NSArray *gpsPointsForTrip = tripCard.simplePath;
    if (gpsPointsForTrip.count > 0) {
        // Get first and mark it as start point
        GpsPoint *first = gpsPointsForTrip[0];
        [self addStartEvent:first.location];

        for (int i = 1; i < gpsPointsForTrip.count - 1; i++) {
            GpsPoint *gpsPoint = [gpsPointsForTrip objectAtIndex:i];
            HTRouteEvent *pathEvent = [[HTRouteEvent alloc]
                                       initWithLocation:gpsPoint.location];
            [self.routePointEvents addObject:pathEvent];
        }

        if (gpsPointsForTrip.count > 1) {
            // Add the end point
            GpsPoint *gpsPoint = [gpsPointsForTrip lastObject];
            [self addEndEvent:gpsPoint.location];
        }

        [self renderPath:self.routePointEvents];
    }

    // Zoom to polyline
    [self setVisibleMapRect:[self.polyline boundingMapRect]
                edgePadding:UIEdgeInsetsMake(40.0, 30.0, 20.0, 30.0) animated:YES];

    // Add trip events
    for (EventCard *eventCard in eventCardsArray) {
        // add as event
        [self addEventCard:eventCard];
    }
}

-(void)addEventCard:(EventCard *)eventCard{
    HTRouteEvent *tripEvent = [[HTRouteEvent alloc]
                               initWithLocation:eventCard.startLocation];
    NSLog(@"%@", eventCard.startLocation);
    tripEvent.eventCard = eventCard;
    [self addAnnotation:tripEvent];
}


//------------------------------------------------------------------------------

- (void) zoomToEventCard:(EventCard*)card
{
    NSInteger index =
    [self.tripEvents indexOfObjectPassingTest:
     ^BOOL(id obj, NSUInteger idx, BOOL* stop)
    {
        HTRouteEvent* event = obj;
        if ([card isEqual:event.eventCard])
        {
            *stop = YES;
            return YES;
        }
        else
        {
            return NO;
        }
    }];

    if (index != NSNotFound)
    {
        HTRouteEvent* event = self.tripEvents[index];
        [self zoomToEvent:event];
    }
}

-(void)zoomToStartLocation{
    NSInteger index =
    [self.tripEvents indexOfObjectPassingTest:
     ^BOOL(id obj, NSUInteger idx, BOOL* stop)
   {
       HTRouteEvent* event = obj;
       if (event.isStartLocation)
       {
           *stop = YES;
           return YES;
       }
       else
       {
           return NO;
       }
   }];

    if (index != NSNotFound) {
        HTRouteEvent* event = self.tripEvents[index];
        [self zoomToEvent:event];
    }
}

-(void)zoomToEndLocation{
    NSInteger index =
    [self.tripEvents indexOfObjectPassingTest:
     ^BOOL(id obj, NSUInteger idx, BOOL* stop)
    {
        HTRouteEvent* event = obj;
        if (event.isEndLocation)
        {
            *stop = YES;
            return YES;
        }
        else
        {
            return NO;
        }
    }];

    if (index != NSNotFound) {
        HTRouteEvent* event = self.tripEvents[index];
        [self zoomToEvent:event];
    }
}

//------------------------------------------------------------------------------
#pragma mark - MKMapViewDelegate
//------------------------------------------------------------------------------

- (void) mapViewWillStartLocatingUser:(MKMapView*)mapView
{
    NSLog(@"Started updating location");
}

//------------------------------------------------------------------------------

- (void) mapViewDidStopLocatingUser:(MKMapView*)mapView
{
    NSLog(@"Stopped updating location");
}

//------------------------------------------------------------------------------

- (void) mapView:(MKMapView*)mapView didUpdateUserLocation:(MKUserLocation*)userLocation
{
    // if this is the first update
    // then zoom to the location
    if (!isZoomedIn)
    {
        if (!self.startEvent) {
            [self addStartEvent:userLocation.location];
        }
        [self zoomToUserLocation:YES];
        isZoomedIn = YES;
    }

    // create an annotation and add it to the route points array
    HTRouteEvent* event = [[HTRouteEvent alloc] initWithLocation:userLocation.location];
    [self.routePointEvents addObject:event];

    // Render the path
    [self renderPath:self.routePointEvents];
}

//------------------------------------------------------------------------------

- (void) mapView:(MKMapView*)mapView didSelectAnnotationView:(MKAnnotationView*)view
{
    if (![[view annotation] isKindOfClass:[MKUserLocation class]]){
        HTRouteEvent* event = (HTRouteEvent*) view.annotation;
        if (event.eventCard != nil &&
            [self.zdMapViewDelegate respondsToSelector:@selector(mapView:didSelectEventCard:)]) {
            [self.zdMapViewDelegate mapView:self didSelectEventCard:event.eventCard];
        }
        else if (event.isStartLocation &&
            [self.zdMapViewDelegate respondsToSelector:@selector(mapViewDidSelectStartLocation:)])
        {
            [self.zdMapViewDelegate mapViewDidSelectStartLocation:self];
        }
        else if (event.isEndLocation &&
            [self.zdMapViewDelegate respondsToSelector:@selector(mapViewDidSelectEndLocation:)])
        {
            [self.zdMapViewDelegate mapViewDidSelectEndLocation:self];
        }
    }
}

//------------------------------------------------------------------------------

- (void) zoomToUserLocation:(BOOL)follow
{
    if (follow)
    {
        [self setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
    else
    {
        MKCoordinateRegion mapRegion;
        mapRegion.center = self.userLocation.coordinate;
        mapRegion.span = MKCoordinateSpanMake(0.01, 0.01);
        [self setRegion:mapRegion animated:YES];
    }
}

//------------------------------------------------------------------------------

- (void) zoomToEvent:(HTRouteEvent*)event
{
    float minimumLatitudeDelta = 0.01;
    float minimumLongitudeDelta = 0.01;
    if(self.region.span.latitudeDelta < minimumLatitudeDelta && self.region.span.longitudeDelta < minimumLongitudeDelta) {

        [UIView animateWithDuration:.3 animations:^{
            [self setCenterCoordinate:event.location.coordinate animated:YES];
        } completion:^(BOOL finished) {
            // Need to bring annotation to front once animation is finished
            MKAnnotationView *annotationView = [self viewForAnnotation:event];
            [annotationView.superview bringSubviewToFront:annotationView];
        }];
    }
    else {
        // Only zoom if not zoomed more than required, otherwise just set the center
        MKCoordinateRegion mapRegion;
        mapRegion.center = event.location.coordinate;
        mapRegion.span = MKCoordinateSpanMake(minimumLatitudeDelta, minimumLongitudeDelta);
        [UIView animateWithDuration:.3 animations:^{
            [self setRegion:mapRegion animated:YES];
        } completion:^(BOOL finished) {
            // Need to bring annotation to front once animation is finished
            MKAnnotationView *annotationView = [self viewForAnnotation:event];
            [annotationView.superview bringSubviewToFront:annotationView];
        }];
    }
}

//------------------------------------------------------------------------------

- (void) addStartEvent:(CLLocation *)location
{
    if (self.startEvent) {
        [self removeAnnotation:self.startEvent];
    }
    self.startEvent = [[HTRouteEvent alloc] initWithLocation:location];
    self.startEvent.isStartLocation = YES;
    [self addAnnotation:self.startEvent];

    [self.routePointEvents addObject:self.startEvent];
    [self.tripEvents addObject:self.startEvent];
}

//------------------------------------------------------------------------------

- (void) addEndEvent:(CLLocation *)location
{
    if (self.endEvent) {
        [self removeAnnotation:self.endEvent];
    }
    self.endEvent = [[HTRouteEvent alloc] initWithLocation:location];
    self.endEvent.isEndLocation = YES;
    [self addAnnotation:self.endEvent];

    [self.routePointEvents addObject:self.endEvent];
    [self.tripEvents addObject:self.endEvent];
}

//------------------------------------------------------------------------------

- (MKAnnotationView*) mapView:(MKMapView*)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // don't know the annotation
    if ([annotation isKindOfClass:HTRouteEvent.class] == NO)
    {
        return nil;
    }

    // start pin
    HTRouteEvent* event = (HTRouteEvent*) annotation;
    if (event.isStartLocation)
    {
        MKPinAnnotationView* view = [[MKPinAnnotationView alloc] initWithAnnotation:event
                                                                    reuseIdentifier:@"startPin"];
        view.animatesDrop = YES;
        view.pinColor = MKPinAnnotationColorGreen;
        return view;
    }

    // end pin
    else if (event.isEndLocation)
    {
        MKPinAnnotationView* view = [[MKPinAnnotationView alloc] initWithAnnotation:event
                                                                    reuseIdentifier:@"endPin"];
        view.animatesDrop = YES;
        view.pinColor = MKPinAnnotationColorRed;
        return view;
    }

    // just a path event
    else if (!event.eventCard)
    {
        return nil;
    }

    // create the view
    // need to dequeue and re-use
    CGRect frame = CGRectMake(0, 0, 26.0, 26.0);
    MKAnnotationView* view = [[MKAnnotationView alloc] initWithFrame:frame];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    imageView.image = [EventCard imageForEventCardType:event.eventCard.eventType];
    [view addSubview:imageView];
    return view;
}

//------------------------------------------------------------------------------

- (void) renderPath:(NSArray*)overlays
{
    if (overlays.count == 0) {
        return;
    }

    // turn overlays into coordinates
    CLLocationCoordinate2D* coordinates = malloc(sizeof(CLLocationCoordinate2D) * overlays.count);
    for (int i = 0; i < overlays.count; ++i)
    {
        HTRouteEvent* overlay = overlays[i];
        coordinates[i] = overlay.coordinate;
    }

    // update polyline
    [self removeOverlay:self.polyline];
    self.polyline = [MKPolyline polylineWithCoordinates:coordinates count:overlays.count];
    [self addOverlay:self.polyline level:MKOverlayLevelAboveRoads];

    // clean up
    free(coordinates);
}

//------------------------------------------------------------------------------

- (MKOverlayRenderer*) mapView:(MKMapView*)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    // polyline of the events
    if (overlay == self.polyline)
    {
        MKPolylineRenderer* renderer = [[MKPolylineRenderer alloc] initWithPolyline:self.polyline];
        renderer.lineCap = kCGLineCapRound;
        renderer.lineWidth = 10;
        renderer.strokeColor = [UIColor pathColor];
        return renderer;
    }

    // otherwise don't know
    return nil;
}

//------------------------------------------------------------------------------
// Just bringing the user location pin above all other annotations
//------------------------------------------------------------------------------
- (void) mapView:(MKMapView *)aMapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *view in views)
    {
        if ([[view annotation] isKindOfClass:[MKUserLocation class]])
        {
            [[view superview] bringSubviewToFront:view];
        }
        else
        {
            [[view superview] sendSubviewToBack:view];
        }
    }
}

//------------------------------------------------------------------------------

@end
