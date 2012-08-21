//
//  GameLocationViewController.m
//  FishTally
//
//  Created by Mark Winkler on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationDetailViewController.h"
#import "Location.h"

@interface LocationDetailViewController ()

@end

@implementation LocationDetailViewController

@synthesize location = _location;
@synthesize mapView = _mapView;
@synthesize bottomToolbar = _bottomToolbar;
@synthesize delegate = _delegate;

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
	if (self.location == nil) {
        self.location = [[Location alloc] init];
        self.location.name = @"New Location";
        self.location.detail = @"";
    } else {
        if ([self.location validRegion]) {
            UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                    target:self
                                    action:@selector(toggleLocation:)];
            NSArray *items = [[NSArray alloc] initWithObjects:btn, nil];
            [self.bottomToolbar setItems:items animated:NO];
            [self.mapView setRegion:self.location.region]; 
            [self.mapView addAnnotation:self.location];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.mapView = nil;
    self.bottomToolbar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)locationChanged 
{    
    MKCoordinateRegion region = self.mapView.region;
    MKCoordinateSpan span = region.span;
    
    self.location.latitudeDelta = [NSNumber numberWithDouble:span.latitudeDelta];
    self.location.longitudeDelta = [NSNumber numberWithDouble:span.longitudeDelta];
    
    [self.delegate locationController:self didSetLocation:self.location];
}

- (void)toggleLocation:(id)sender {
    if (![self.location validRegion]) {
        // set location
        CLLocationCoordinate2D centerCoordinate = self.mapView.centerCoordinate;
        self.location.latitude = [NSNumber numberWithDouble:centerCoordinate.latitude];
        self.location.longitude = [NSNumber numberWithDouble:centerCoordinate.longitude];
        [self.mapView addAnnotation:self.location];
    
        UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                  target:self
                                                  action:@selector(toggleLocation:)];
        NSArray *items = [[NSArray alloc] initWithObjects:btn, nil];
        [self.bottomToolbar setItems:items animated:NO];
        [self locationChanged];
        
    } else {
        // clear location
        self.location.latitude = nil;
        self.location.longitude = nil;
        self.location.latitudeDelta = nil;
        self.location.longitudeDelta = nil;
        
        [self.mapView removeAnnotation:self.location];
        
        UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                                initWithImage:[UIImage imageNamed:@"Pin.png"]
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(toggleLocation:)];
        NSArray *items = [[NSArray alloc] initWithObjects:btn, nil];
        [self.bottomToolbar setItems:items animated:NO];
        [self.delegate locationController:self didSetLocation:self.location];
    }
}

#pragma mark - MKMapViewDelegate

- (void)showLocationDetails:(UIButton *)button
{
    [self performSegueWithIdentifier:@"EditLocation" sender:button];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[Location class]]) {
        
        static NSString *identifier = @"Location";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = YES;
            annotationView.draggable = YES;
            annotationView.pinColor = MKPinAnnotationColorGreen;
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView 
                            didChangeDragState:(MKAnnotationViewDragState)newState 
                                fromOldState:(MKAnnotationViewDragState)oldState 
{
    if (newState == MKAnnotationViewDragStateEnding) {
        [self locationChanged];
    }
}

@end
