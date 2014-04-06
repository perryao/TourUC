//
//  AppDelegate.m
//  Groceries
//
//  Created by Mike Perry on 4/5/14.
//  Copyright (c) 2014 Anthony Perry. All rights reserved.
//

#import "AppDelegate.h"
#import "BeaconMonitoringService.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<CLLocationManagerDelegate>

@property (strong,nonatomic)CLLocationManager *locationManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    [[BeaconMonitoringService sharedInstance]stopMonitoringAllRegions];
    NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:@"C3CACDAD-5501-4DA6-B240-5F588C2AF0B2"];
    [[BeaconMonitoringService sharedInstance]startMonitoringBeaconWithUUID:uuid major:0 minor:0 identifier:@"com.anthonymichaelperry.groceriesList" onEntry:YES onExit:YES];



    return YES;
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        //CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    }

}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        UILocalNotification *notification = [UILocalNotification new];
        notification.alertBody = [NSString stringWithFormat:@"You're near the iBeacon"];
        notification.soundName = @"Default";
        [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];

    }

}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        UILocalNotification *notification = [UILocalNotification new];
        notification.alertBody = @"You just left the range of the iBeacon";
        notification.soundName = @"Default";
        [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    CLBeacon *beacon;
    for (CLBeacon *arrayBeacon in beacons) {
        NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:@"C3CACDAD-5501-4DA6-B240-5F588C2AF0B2"];
        if ([arrayBeacon.proximityUUID isEqual:uuid]) {
            beacon = arrayBeacon;

        }


    }


    if (beacon.rssi >= -40 && beacon.rssi <=-30) {
        UILocalNotification *notification = [UILocalNotification new];
        notification.alertBody = [NSString stringWithFormat:@"Welcome to aisle 1. Measured RSSI of %ld", (long)beacon.rssi];
        notification.soundName = @"Default";
        [[UIApplication sharedApplication]presentLocalNotificationNow:notification];

    }


//    if (beacon.proximity == CLProximityImmediate) {
//        UILocalNotification *notification = [UILocalNotification new];
//        notification.alertBody = @"You are very close to the iBeacon";
//        notification.soundName = @"Default";
//        [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
//    }else if (beacon.proximity == CLProximityNear){
//        UILocalNotification *notification = [UILocalNotification new];
//        notification.alertBody = @"You're near to the iBeacon but can get closer";
//        notification.soundName = @"Default";
//        [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
//    }else if (beacon.proximity == CLProximityFar){
//        UILocalNotification *notification = [UILocalNotification new];
//        notification.alertBody = @"You are far from the iBeacon";
//        notification.soundName = @"Default";
//        [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
//    }

}

@end
