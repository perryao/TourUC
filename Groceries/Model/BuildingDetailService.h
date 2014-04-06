//
//  BuildingDetailService.h
//  Groceries
//
//  Created by Mike Perry on 4/6/14.
//  Copyright (c) 2014 Anthony Perry. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Building;
@interface BuildingDetailService : NSObject

+(BuildingDetailService *)sharedInstance;

- (Building *)buildingWithUUID:(NSUUID *)uuid;



@end
