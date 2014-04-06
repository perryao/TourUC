//
//  DetailViewController.h
//  TourUC
//
//  Created by Mike Perry on 4/6/14.
//  Copyright (c) 2014 Anthony Perry. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Building;

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property(strong,nonatomic)Building *buildingToDisplay;


@end
