//
//  CatchDislayViewController.m
//  FishTally
//
//  Created by Mark Winkler on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CatchDislayViewController.h"
#import "Catch.h"
#import "CatchDetailViewController.h"
#import "UIImage+Resize.h"
#import "Fish.h"
#import "Lure.h"

@interface CatchDislayViewController ()

@end

@implementation CatchDislayViewController

@synthesize fishLabel = _fishLabel;
@synthesize dateLabel = _dateLabel;
@synthesize sizeLabel = _sizeLabel;
@synthesize locationLabel = _locationLabel;
@synthesize lureLabel = _lureLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize textView = _textView;
@synthesize fishImageView = _fishImageView;
@synthesize lureImageView = _lureImageView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize catch = _catch;

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
	if (self.catch) {
        UIImage *image = nil;
        if ([self.catch hasPhoto]) {
            image = [self.catch photoImage];
            if (image != nil) {
                image = [image resizedImageWithBounds:CGSizeMake(120, 120) withAspectType:ImageAspectTypeFit];
            }
        } else {
            if ([self.catch.fish hasPhoto]) {
                image = [self.catch.fish photoImage];
                if (image != nil) {
                    image = [image resizedImageWithBounds:CGSizeMake(120, 120) withAspectType:ImageAspectTypeFit];
                }
            }
        }
        self.fishImageView.image = image;
        
        image = nil;
        
        if ([self.catch.lure hasPhoto]) {
            image = [self.catch.lure photoImage];
            if (image != nil) {
                image = [image resizedImageWithBounds:CGSizeMake(60, 60) withAspectType:ImageAspectTypeFit];
            }
        }
        self.lureImageView.image = image;
        self.fishLabel.text = self.catch.fish.name;
        self.dateLabel.text = self.catch.dateString;
        self.sizeLabel.text = @"TODO: add size string to catch";
        self.scoreLabel.text = self.catch.scoreString;
        self.locationLabel.text = [NSString stringWithFormat:@"%.1f, %.1f", [self.catch.latitude doubleValue], [self.catch.longitude doubleValue]];
        self.lureLabel.text = self.catch.lure.name;
        self.scoreLabel.text = self.catch.scoreString;
        self.textView.text = self.catch.comment;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)edit:(id)sender {
    
}

@end
