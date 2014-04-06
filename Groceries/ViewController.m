//
//  ViewController.m
//  Groceries
//
//  Created by Mike Perry on 4/5/14.
//  Copyright (c) 2014 Anthony Perry. All rights reserved.
//

#import "ViewController.h"
#import "Building.h"
#import "BeaconMonitoringService.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()<CLLocationManagerDelegate,UINavigationBarDelegate>

@property(strong,nonatomic)CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;

@end

@implementation ViewController


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.navigationController.navigationBar.barTintColor = [UIColor redColor];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];


    }
    return self;
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleWelcomeNotification:) name:@"BYBEACON" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleGoodbyeNotification:) name:@"DIDLEAVEBEACON" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];



}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handleWelcomeNotification:(NSNotification *)notification
{
    Building *building = (Building *)notification.object;
    self.proximityLabel.text = [NSString stringWithFormat:@"Welcome to %@", building.name];


    NSString *path =[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", building.name] ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];


    MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:controller];
    [controller.moviePlayer play];

}



- (void)handleGoodbyeNotification:(NSNotification *)notification
{
    Building *building = (Building *)notification.object;
    self.proximityLabel.text = [NSString stringWithFormat:@"Thanks for visiting %@", building.name];
}

- (void)playbackStateChanged:(NSNotification *)notification
{
    

}








@end
