//
//  BeaconMonitoringService.h
//  Groceries
//
//  Created by Mike Perry on 4/5/14.
//  Copyright (c) 2014 Anthony Perry. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface BeaconMonitoringService : NSObject

+(BeaconMonitoringService *)sharedInstance;

- (void)startMonitoringBeaconWithUUID:(NSUUID *)uuid
                                major:(CLBeaconMajorValue)major
                                minor:(CLBeaconMinorValue)minor
                           identifier:(NSString *)identifier
                              onEntry:(BOOL)entry
                               onExit:(BOOL)exit;


- (void)stopMonitoringAllRegions;

@end
