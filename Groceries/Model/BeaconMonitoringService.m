//
//  BeaconMonitoringService.m
//  Groceries
//
//  Created by Mike Perry on 4/5/14.
//  Copyright (c) 2014 Anthony Perry. All rights reserved.
//

#import "BeaconMonitoringService.h"

@interface BeaconMonitoringService ()

@property (strong,nonatomic)CLLocationManager *locationManager;

@end

@implementation BeaconMonitoringService

+ (BeaconMonitoringService *)sharedInstance
{
    static dispatch_once_t onceToken;
    static BeaconMonitoringService *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _locationManager = [CLLocationManager new];
    return self;
}

- (void)startMonitoringBeaconWithUUID:(NSUUID *)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor identifier:(NSString *)identifier onEntry:(BOOL)entry onExit:(BOOL)exit
{
    CLBeaconRegion *region = [[CLBeaconRegion alloc]initWithProximityUUID:uuid major:major minor:minor identifier:identifier];
    region.notifyOnEntry = entry;
    region.notifyOnExit = exit;
    region.notifyEntryStateOnDisplay = YES;
    [self.locationManager startMonitoringForRegion:region];
}


- (void)stopMonitoringAllRegions
{
    for (CLRegion *region in self.locationManager.monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:region];
    }
}



@end
