//
//  CatchDislayViewController.m
//  FishTally
//
//  Created by Mark Winkler on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CatchDisplayViewController.h"
#import "Catch.h"
#import "CatchDetailViewController.h"
#import "UIImage+Resize.h"
#import "Fish.h"
#import "Lure.h"
#import "Player.h"

@interface CatchDisplayViewController ()

@end

@implementation CatchDisplayViewController

@synthesize fishLabel = _fishLabel;
@synthesize familyLabel = _familyLabel;
@synthesize dateLabel = _dateLabel;
@synthesize sizeLabel = _sizeLabel;
@synthesize locationLabel = _locationLabel;
@synthesize lureLabel = _lureLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize lureMultiplierLabel = _lureMultiplierLabel;
@synthesize sizeMultiplierLabel = _sizeMultiplierLabel;
@synthesize pointsLabel = _pointsLabel;
@synthesize textView = _textView;
@synthesize fishImageView = _fishImageView;
@synthesize playerImageView = _playerImageView;
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
                image = [image resizedImageWithBounds:CGSizeMake(160, 120) withAspectType:ImageAspectTypeFit];
            }
        } else {
            if ([self.catch.fish hasPhoto]) {
                image = [self.catch.fish photoImage];
                if (image != nil) {
                    image = [image resizedImageWithBounds:CGSizeMake(160, 120) withAspectType:ImageAspectTypeFit];
                }
            }
        }
        self.fishImageView.image = image;
        
        image = nil;
        
        if ([self.catch.player hasPhoto]) {
            image = [self.catch.player photoImage];
            if (image != nil) {
                image = [image resizedImageWithBounds:CGSizeMake(60, 60) withAspectType:ImageAspectTypeFill];
            }
        }
        self.playerImageView.image = image;
        
        self.fishLabel.text = self.catch.fish.name;
        self.familyLabel.text = self.catch.fish.familyName;
        self.sizeLabel.text = [NSString stringWithFormat:@"%@ %@", self.catch.sizeName, self.catch.scoreString];
        
        self.dateLabel.text = self.catch.dateString;
        
        self.locationLabel.text = [NSString stringWithFormat:@"%.1f, %.1f", [self.catch.latitude doubleValue], [self.catch.longitude doubleValue]];
        self.lureLabel.text = self.catch.lure.name;
        
        self.pointsLabel.text = [NSString stringWithFormat:@"%d", [self.catch.fish.points integerValue]];
        self.lureMultiplierLabel.text = [NSString stringWithFormat:@"%.1f", [self.catch.lure.multiplier doubleValue]];
        self.sizeMultiplierLabel.text = [NSString stringWithFormat:@"%.1f", [self.catch.sizeMultiplier doubleValue]];
        self.scoreLabel.text = [NSString stringWithFormat:@"%.1f", [self.catch.score doubleValue]];;
        
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
