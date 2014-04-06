//
//  DetailViewController.m
//  TourUC
//
//  Created by Mike Perry on 4/6/14.
//  Copyright (c) 2014 Anthony Perry. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImage+Resize.h"
#import "Building.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.buildingToDisplay) {
        self.imageView.image = [self.buildingToDisplay.image resizedImageWithBounds:CGSizeMake(320, 183)];
        self.textView.text = self.buildingToDisplay.detail;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
