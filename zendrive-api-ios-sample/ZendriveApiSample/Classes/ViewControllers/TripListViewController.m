//
//  MasterViewController.m
//  ZendriveApiSample
//
//  Created by Yogesh Maheshwari on 07/01/15.
//  Copyright (c) 2015 Zendrive. All rights reserved.
//

#import "TripListViewController.h"
#import "TripDetailsViewController.h"

#import "ZendriveAPI.h"
#import "MBProgressHUD.h"
#import "GeneralConstants.h"

#import "TripCard.h"

@interface TripListViewController ()

@property NSMutableArray *trips;
@end

@implementation TripListViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshTrips];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Api calls

- (void)refreshTrips {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[ZendriveAPI sharedInstance]
     fetchTripsForUser:kUserId completion:^(NSArray *trips, NSError *error) {
         if (error) {
             [[[UIAlertView alloc] initWithTitle:@"Oops!!" message:error.localizedDescription
                                        delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
         }
         else {
             self.trips = [trips mutableCopy];
             [self.tableView reloadData];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TripCard *trip = self.trips[indexPath.row];
        [[segue destinationViewController] setTrip:trip];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripCell" forIndexPath:indexPath];

    TripCard *trip = self.trips[indexPath.row];
    cell.textLabel.text = trip.tripId;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ to %@", trip.startDate, trip.endDate];
    return cell;
}

@end
