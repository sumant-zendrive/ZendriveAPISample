//
//  ZDMapView.h
//  
//
//  Created by Yogesh Maheshwari on 10/09/14.
//  Copyright (c) 2014 Zendrive. All rights reserved.
//

#import <MapKit/MapKit.h>


@class EventCard, TripCard;
@class ZDMapView;

@protocol ZDMapViewDelegate <NSObject>

@optional
- (void) mapView:(ZDMapView*)mapView didSelectEventCard:(EventCard*)eventCard;
- (void) mapViewDidSelectStartLocation:(ZDMapView*)mapView;
- (void) mapViewDidSelectEndLocation:(ZDMapView*)mapView;
@end

@interface ZDMapView : MKMapView

@property (nonatomic, weak) id<ZDMapViewDelegate> zdMapViewDelegate;

- (void) setTripCard:(TripCard *)tripCard andEventCardsArray:(NSArray *)array;
- (void) zoomToEventCard:(EventCard*)card;
- (void) zoomToStartLocation;
- (void) zoomToEndLocation;
@end
