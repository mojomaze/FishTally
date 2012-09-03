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
- (void)updateLabels;
- (void)showLandscapeViewWithDuration:(NSTimeInterval)duration;
- (void)hideLandscapeViewWithDuration:(NSTimeInterval)duration;
- (void)createLandscapeCommentViewWithRotation:(BOOL)rotation;
@end

@implementation CatchDisplayViewController {
    UIView *landscapeCommentView;
    UITextView *landscapeTextView;
}

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
@synthesize portraitCommentView = _portraitCommentView;
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
        
        [self updateLabels];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextDidChange:)
                                                     name:NSManagedObjectContextObjectsDidChangeNotification
                                                   object:self.managedObjectContext];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.fishLabel = nil;
    self.familyLabel = nil;
    self.dateLabel = nil;
    self.sizeLabel = nil;
    self.locationLabel = nil;
    self.lureLabel = nil;
    self.scoreLabel = nil;
    self.lureMultiplierLabel = nil;
    self.sizeMultiplierLabel = nil;
    self.pointsLabel = nil;
    self.textView = nil;
    self.fishImageView = nil;
    self.playerImageView = nil;
    self.portraitCommentView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSManagedObjectContextObjectsDidChangeNotification
                                                  object:self.managedObjectContext];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSManagedObjectContextObjectsDidChangeNotification
                                                  object:self.managedObjectContext];
}

- (void)contextDidChange:(NSNotification *)notification
{
    NSSet *updated = [[notification userInfo] objectForKey:NSUpdatedObjectsKey];
    if (updated != nil) {
        NSArray *catches = [updated allObjects];
        
        for (Catch *catch in catches) {
            if ([catch isEqual:self.catch]) {
                self.catch = catch;
                [self updateLabels];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    NSTimeInterval duration = 0.0f;
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self hideLandscapeViewWithDuration:duration];
    } else {
        [self showLandscapeViewWithDuration:duration];

    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        [self hideLandscapeViewWithDuration:duration];
    } else {
        [self showLandscapeViewWithDuration:duration];
    }
}

- (void)updateLabels {
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
    
    self.pointsLabel.text = [NSString stringWithFormat:@"%d.0", [self.catch.fish.points integerValue]];
    self.lureMultiplierLabel.text = [NSString stringWithFormat:@"%.1f", [self.catch.lure.multiplier doubleValue]];
    self.sizeMultiplierLabel.text = [NSString stringWithFormat:@"%.1f", [self.catch.sizeMultiplier doubleValue]];
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f", [self.catch.score doubleValue]];;
    
    NSString *comment = self.catch.comment;
    if (comment == nil || [comment isEqualToString:@""]) {
        comment = @"No Comment";
    }
    
    self.textView.text = comment;
    
    if (landscapeTextView) {
        landscapeTextView.text = comment;
    }
}

- (void)createLandscapeCommentViewWithRotation:(BOOL)rotation {
    // rotation is portait going to landscape
    CGRect  viewRect;
    if (rotation) {
        viewRect = CGRectMake(160, 160, 140, 200); // portrait to landscape position
    } else {
        viewRect = CGRectMake(320, 10, 140, 200); // initial landscape position
    }
    
    // parent view
    landscapeCommentView = [[UIView alloc] initWithFrame:viewRect];
    landscapeCommentView.alpha = 0.0f;
    //landscapeCommentView.backgroundColor = [[UIColor alloc] initWithWhite:1.0f alpha:1.0f];
    landscapeCommentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    // child UIImageView for styling
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Panel-black-light.png"]];
    imageView.frame = landscapeCommentView.bounds;
    [landscapeCommentView addSubview:imageView];
    // child UITextView for comments
    landscapeTextView = [[UITextView alloc] initWithFrame:landscapeCommentView.bounds];
    landscapeTextView.backgroundColor = [UIColor clearColor];
    landscapeTextView.editable = NO;
    landscapeTextView.textColor = [UIColor whiteColor];
    landscapeTextView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    NSString *comment = self.catch.comment;
    if (comment == nil || [comment isEqualToString:@""]) {
        comment = @"No Comment";
    }
    
    landscapeTextView.text = comment;
    [landscapeCommentView addSubview:landscapeTextView];
    [self.view addSubview:landscapeCommentView];
}

- (void)hideLandscapeViewWithDuration:(NSTimeInterval)duration {
    if (landscapeCommentView) {
        self.portraitCommentView.hidden = NO;
        [UIView animateWithDuration:duration animations:^{
            landscapeCommentView.alpha = 0.0f;
            self.portraitCommentView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            landscapeCommentView.hidden = YES;
        }];
    } else {
        self.portraitCommentView.hidden = NO;
    }
    
}

- (void)showLandscapeViewWithDuration:(NSTimeInterval)duration {
    if (!landscapeCommentView) {
        [self createLandscapeCommentViewWithRotation:duration > 0.0f];
    } else {
        landscapeCommentView.hidden = NO;
    }
    [UIView animateWithDuration:duration animations:^{
        landscapeCommentView.alpha = 1.0f;
        self.portraitCommentView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.portraitCommentView.hidden = YES;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // edit catch called from accessory button
    if ([segue.identifier isEqualToString:@"EditCatch"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CatchDetailViewController *controller = (CatchDetailViewController *)navigationController.topViewController;
        controller.managedObjectContext = self.managedObjectContext;
        
        controller.catchToEdit = self.catch;
        controller.player = self.catch.player;
    }
}

@end
