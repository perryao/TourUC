//
//  AppDelegate.m
//  Groceries
//
//  Created by Mike Perry on 4/5/14.
//  Copyright (c) 2014 Anthony Perry. All rights reserved.
//

#import "AppDelegate.h"
#import "BeaconMonitoringService.h"
#import "BuildingDetailService.h"
#import "Building.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<CLLocationManagerDelegate>

@property (strong,nonatomic)CLLocationManager *locationManager;
@property (strong,nonatomic)CLBeacon *mostRecentBeacon;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    [[BeaconMonitoringService sharedInstance]stopMonitoringAllRegions];
    NSUUID *baldwinUUID = [[NSUUID alloc]initWithUUIDString:@"C3CACDAD-5501-4DA6-B240-5F588C2AF0B2"];
    NSUUID *pavilionUUID =[[NSUUID alloc]initWithUUIDString:@"7B377E4A-1641-4765-95E9-174CD05B6C79"];
    [[BeaconMonitoringService sharedInstance]startMonitoringBeaconWithUUID:baldwinUUID major:0 minor:0 identifier:@"com.anthonymichaelperry.tourClient1" onEntry:YES onExit:YES];
    [[BeaconMonitoringService sharedInstance]startMonitoringBeaconWithUUID:pavilionUUID major:1 minor:1 identifier:@"com.anthonymichaelperry.tourClient" onEntry:YES onExit:YES];



    return YES;
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"Did determine state");
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        //CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    }

}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Did enter a region");
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
    NSLog(@"Did exit a region");
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        UILocalNotification *notification = [UILocalNotification new];
        notification.alertBody = @"You just left the range of the iBeacon";
        notification.soundName = @"Default";
        [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
        [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"Did range beacons %@",beacons);
    CLBeacon *baldwinBeacon;
    CLBeacon *pavilionBeacon;
    NSUUID *baldwinUUID = [[NSUUID alloc]initWithUUIDString:@"C3CACDAD-5501-4DA6-B240-5F588C2AF0B2"];
    NSUUID *pavilionUUID =[[NSUUID alloc]initWithUUIDString:@"7B377E4A-1641-4765-95E9-174CD05B6C79"];


    for (CLBeacon *arrayBeacon in beacons) {
        NSString *stringValue = [[arrayBeacon proximityUUID]UUIDString];
        if ([stringValue isEqualToString:[baldwinUUID UUIDString]]) {
            baldwinBeacon = arrayBeacon;

        }else if ([stringValue isEqualToString:[pavilionUUID UUIDString]]){
            pavilionBeacon = arrayBeacon;
        }


    }


    if (baldwinBeacon.rssi >= -80 && baldwinBeacon.rssi <=-10 && ![baldwinBeacon.proximityUUID.UUIDString isEqualToString:self.mostRecentBeacon.proximityUUID.UUIDString]) {
        self.mostRecentBeacon = baldwinBeacon;
        Building *building = [[BuildingDetailService sharedInstance]buildingWithUUID:baldwinUUID];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"BYBEACON" object:building];
        UILocalNotification *notification = [UILocalNotification new];
        notification.alertBody = [NSString stringWithFormat:@"Welcome to %@", building.name];
        notification.soundName = @"Default";
        [[UIApplication sharedApplication]presentLocalNotificationNow:notification];

    }else if (pavilionBeacon.rssi >= -80 && pavilionBeacon.rssi <=-10 && ![pavilionBeacon.proximityUUID.UUIDString isEqualToString:self.mostRecentBeacon.proximityUUID.UUIDString]) {
        self.mostRecentBeacon = pavilionBeacon;
        Building *building = [[BuildingDetailService sharedInstance]buildingWithUUID:pavilionUUID];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"BYBEACON" object:building];
        UILocalNotification *notification = [UILocalNotification new];
        notification.alertBody = [NSString stringWithFormat:@"Welcome to %@", building.name];
        notification.soundName = @"Default";
        [[UIApplication sharedApplication]presentLocalNotificationNow:notification];

    }

    if (baldwinBeacon.rssi < -80) {
        Building *building = [[BuildingDetailService sharedInstance]buildingWithUUID:baldwinUUID];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DIDLEAVEBEACON" object:building];
        UILocalNotification *notification = [UILocalNotification new];
        notification.alertBody = [NSString stringWithFormat:@"Thanks for visiting %@", building.name];
        notification.soundName = @"Default";
        [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
    }else if (pavilionBeacon.rssi < -80) {
        Building *building = [[BuildingDetailService sharedInstance]buildingWithUUID:pavilionUUID];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DIDLEAVEBEACON" object:building];
        UILocalNotification *notification = [UILocalNotification new];
        notification.alertBody = [NSString stringWithFormat:@"Thanks for visiting %@", building.name];
        notification.soundName = @"Default";
        [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
    }




}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}


@end
