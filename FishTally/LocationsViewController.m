//
//  LocationsViewController.m
//  FishTally
//
//  Created by Mark Winkler on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationsViewController.h"
#import "Game.h"
#import "PlayersViewController.h"
#import "Player.h"
#import "UIImage+Resize.h"
#import "Catch.h"
#import "CatchDisplayViewController.h"

@interface LocationsViewController ()
- (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations;
@end

@implementation LocationsViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize managedObjectContext = _managedObjectContext;

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
	if ([self.annotations count] > 0) {
        MKCoordinateRegion region = [self regionForAnnotations:self.annotations];
        [self.mapView setRegion:region animated:YES];
        [self.mapView addAnnotations:self.annotations];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.mapView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations
{
    MKCoordinateRegion region;
    
    if ([annotations count] == 1) {
        id <MKAnnotation> annotation = [annotations lastObject];
        region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 5000, 5000);
        
    } else {
        CLLocationCoordinate2D topLeftCoord;
        topLeftCoord.latitude = -90;
        topLeftCoord.longitude = 180;
        
        CLLocationCoordinate2D bottomRightCoord;
        bottomRightCoord.latitude = 90;
        bottomRightCoord.longitude = -180;
        
        for (id <MKAnnotation> annotation in annotations)
        {
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        }
        
        const double extraSpace = 1.2;
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2.0;
        region.center.longitude = topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2.0;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace;
        region.span.longitudeDelta = fabs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace;
    }
    
    return [self.mapView regionThatFits:region];
}

#pragma mark - MKMapViewDelegate

- (void)showGame:(UIButton *)button
{
    [self performSegueWithIdentifier:@"GamePlayers" sender:button];
}

- (void)showCatch:(UIButton *)button
{
    [self performSegueWithIdentifier:@"ShowCatch" sender:button];
}

- (UIImage *)leadingPlayerImageForGame:(Game *)game {
    // get the leading player to show picture
    UIImage *image;
    Player *player = [game leadingPlayer];
    if (player != nil) {
        if ([player hasPhoto]) {
            image = [player photoImage];
            if (image != nil) {
                image = [image resizedImageWithBounds:CGSizeMake(32, 32) withAspectType:ImageAspectTypeFill];
            }
        }
    }
    return image;
}

- (UIImage *)playerPhotoForCatch:(Catch *)catch {
    // get the leading player to show picture
    UIImage *image;
    Player *player = catch.player;
    if (player != nil) {
        if ([player hasPhoto]) {
            image = [player photoImage];
            if (image != nil) {
                image = [image resizedImageWithBounds:CGSizeMake(32, 32) withAspectType:ImageAspectTypeFill];
            }
        }
    }
    return image;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[Game class]]) {
        
        Game *game = annotation;
        UIImageView *imageView;
        UIImage *image = [self leadingPlayerImageForGame:game];
        if (image != nil) {
            imageView = [[UIImageView alloc] initWithImage:image];
        }
        
        static NSString *identifier = @"Game";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = YES;
            annotationView.draggable = NO;
            annotationView.pinColor = MKPinAnnotationColorGreen;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self action:@selector(showGame:) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = rightButton;
            annotationView.leftCalloutAccessoryView = imageView;
            
        } else {
            annotationView.annotation = annotation;
        }
        
        UIButton *button = (UIButton *)annotationView.rightCalloutAccessoryView;
        button.tag = [self.annotations indexOfObject:(Game *)annotation];
        
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[Catch class]]) {
        
        Catch *catch = annotation;
        
        UIImageView *imageView;
        UIImage *image = [self playerPhotoForCatch:catch];
        if (image != nil) {
            imageView = [[UIImageView alloc] initWithImage:image];
        }
        
        static NSString *identifier = @"Catch";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = YES;
            annotationView.draggable = NO;
            annotationView.pinColor = MKPinAnnotationColorGreen;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self action:@selector(showCatch:) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = rightButton;
            annotationView.leftCalloutAccessoryView = imageView;
            
        } else {
            annotationView.annotation = annotation;
        }
        
        UIButton *button = (UIButton *)annotationView.rightCalloutAccessoryView;
        button.tag = [self.annotations indexOfObject:(Catch *)annotation];
        
        return annotationView;
    }
    
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GamePlayers"]) {
        Game *game = [self.annotations objectAtIndex:((UIButton *)sender).tag];
        PlayersViewController *viewController = segue.destinationViewController;
        viewController.managedObjectContext = self.managedObjectContext;
        viewController.game = game;
    }
    
    if ([segue.identifier isEqualToString:@"ShowCatch"]) {
        Catch *catch = [self.annotations objectAtIndex:((UIButton *)sender).tag];
        CatchDisplayViewController *viewController = segue.destinationViewController;
        viewController.managedObjectContext = self.managedObjectContext;
        viewController.catch = catch;
    }
}

@end
