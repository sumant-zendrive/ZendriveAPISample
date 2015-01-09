//
//  DetailViewController.m
//  ZendriveApiSample
//
//  Created by Yogesh Maheshwari on 07/01/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import "TripDetailsViewController.h"

#import "ZDMapView.h"

#import "MBProgressHUD.h"
#import "ZendriveAPI.h"
#import "GeneralConstants.h"

#import "TripCard.h"
#import "EventCard.h"

@interface TripDetailsViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *numberOfEventsLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *driveTimeLabel;
@property (nonatomic, weak) IBOutlet ZDMapView *mapView;
@end

@implementation TripDetailsViewController

#pragma mark - Managing the detail item

- (void)setTrip:(id)newDetailItem {
    if (_trip != newDetailItem) {
        _trip = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Fetch trip details
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[ZendriveAPI sharedInstance] fetchDetailsForTrip:self.trip user:kUserId completion:
     ^(TripCard *trip, NSError *error) {
         if (error) {
             [[[UIAlertView alloc] initWithTitle:@"Oops!!" message:error.localizedDescription
                                        delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
         }
         else {
             // Refresh UI
             self.trip = trip;
             [self.mapView setTripCard:trip andEventCardsArray:trip.events];
             [self.tableView reloadData];
             self.numberOfEventsLabel.text =
             [NSString stringWithFormat:@"%lu", (unsigned long)trip.events.count];

             int hours = trip.driveTime/(60*60);
             int minutes = trip.driveTime/(60) - hours*60;
             self.driveTimeLabel.text = [NSString stringWithFormat:@"%i:%i", hours, minutes];
             self.distanceLabel.text = [NSString stringWithFormat:@"%.2f", trip.distance/1609.34];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trip.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];

    EventCard *event = self.trip.events[indexPath.row];
    cell.textLabel.text = [EventCard titleForEventCardType:event.eventType];
    return cell;
}

@end
