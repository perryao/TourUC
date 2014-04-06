//
//  BuildingDetailService.m
//  Groceries
//
//  Created by Mike Perry on 4/6/14.
//  Copyright (c) 2014 Anthony Perry. All rights reserved.
//

#import "BuildingDetailService.h"
#import "Building.h"

@implementation BuildingDetailService

+ (BuildingDetailService *)sharedInstance
{
    static dispatch_once_t onceToken;
    static BuildingDetailService *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

- (Building *)buildingWithUUID:(NSUUID *)uuid
{
    Building *building = [Building new];
    NSString *uuidString = [uuid UUIDString];
    if ([uuidString isEqualToString:@"C3CACDAD-5501-4DA6-B240-5F588C2AF0B2"]) {
        building.name = @"Baldwin Hall";
    }else if ([uuidString isEqualToString:@"7B377E4A-1641-4765-95E9-174CD05B6C79"]){
        building.name = @"UC Pavilion";
    }
    return building;
}



@end