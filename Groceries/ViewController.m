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
#import "BuildingCell.h"
#import "UIImage+Resize.h"
#import "DetailViewController.h"

@interface ViewController ()<CLLocationManagerDelegate,UINavigationBarDelegate>

@property(strong,nonatomic)CLLocationManager *locationManager;

@property (strong,nonatomic)NSMutableArray *buildings;
@property (strong,nonatomic)MPMoviePlayerViewController *moviePlayerController;


@end

@implementation ViewController




- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.navigationController.navigationBar.barTintColor = [UIColor redColor];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
        _buildings = [NSMutableArray new];

        Building *building = [Building new];
        building.name = @"Baldwin";
        building.image = [UIImage imageNamed:@"baldwinhall"];
        building.detail = @"Constructed in 1911, Baldwin Hall is the headquarters for the College administration and academic classrooms. The 80,600 NSF building was reopened January 2002 with computing laboratories, electronic classroom, and seminar rooms";
        [_buildings addObject:building];

        building = [Building new];
        building.name = @"UC Pavilion";
        building.image = [UIImage imageNamed:@"pavilion"];
        building.detail = @"University Pavilion is where the president of the university, Santa Ono, has his office. It is home to Financial Aid and Undergraduate Admissions and also serves as a campus “one stop” center. It is the place where students can pay bills, add/drop classes, and learn about financial aid. It houses the University’s Veteran Affairs office, Career Development Center, Testing Center, Disabilities Services, Tutoring Services, and more! When the University Pavilion was finished, UC was one of only three campuses nationwide that had a “one stop” type of place.";
        [_buildings addObject:building];

        building = [Building new];
        building.image = [UIImage imageNamed:@"engineeringResearchCenter"];
        building.name = @"Engineering Research Center";
        building.detail = @"The new Engineering Research Center opened in June 1995 and is a focal point of College research. The 158,592 NSF facility houses state-of-the-art research laboratories and offices for graduate students and faculty. Designed by internationally-known architect Michael Graves, in conjunction with the Cincinnati-based firm KZF, the facility is conveniently located adjacent to the existing engineering complex";
        [_buildings addObject:building];


        building = [Building new];
        building.name = @"Old Chemistry Building";
        building.detail = @"Located in the Schneider Quadrangle, the College utilizes over 16,672 NASF for offices, classrooms, and laboratories. Many engineering departments share the space for sponsored research, general administrative activities, instruction, and program support";
        building.image = [UIImage imageNamed:@"oldChem"];
        [_buildings addObject:building];


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


    NSString *path =[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", building.name] ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];

    self.moviePlayerController.moviePlayer.contentURL = url;
    [self.moviePlayerController.moviePlayer prepareToPlay];
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerController];
    [self.moviePlayerController.moviePlayer play];


}

- (MPMoviePlayerViewController *)moviePlayerController
{
    if (_moviePlayerController == nil) {
        _moviePlayerController = [MPMoviePlayerViewController new];
    }
    return _moviePlayerController;
}



- (void)handleGoodbyeNotification:(NSNotification *)notification
{
    //Building *building = (Building *)notification.object;

}

- (void)playbackStateChanged:(NSNotification *)notification
{


}



-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationPortrait)
        return YES;

    return NO;
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_buildings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    BuildingCell *buildingCell = (BuildingCell *)cell;
    Building *building = (Building *)_buildings[indexPath.row];
    buildingCell.nameLabel.text = building.name;
    buildingCell.buildingImageView.image = [building.image resizedImageWithBounds:CGSizeMake(64, 64)];



}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowBuildingDetail"]) {
        DetailViewController *controller = (DetailViewController*)segue.destinationViewController;
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        controller.buildingToDisplay = _buildings[indexPath.row];
    }

}










@end
