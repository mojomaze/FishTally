//
//  GameLocationViewController.m
//  FishTally
//
//  Created by Mark Winkler on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLocationViewController.h"
#import "Location.h"

@interface GameLocationViewController ()

@end

@implementation GameLocationViewController

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
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)toggleLocation:(id)sender {
    if (self.location.longitude == nil) {
        // set location
        CLLocationCoordinate2D centerCoordinate = self.mapView.centerCoordinate;
        self.location.latitude = [NSNumber numberWithDouble:centerCoordinate.latitude];
        self.location.longitude = [NSNumber numberWithDouble:centerCoordinate.longitude];
        [self.mapView addAnnotation:self.location];
        
    } else {
        // clear location
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
            annotationView.pinColor = MKPinAnnotationColorGreen;
            
            //UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            //[rightButton addTarget:self action:@selector(showLocationDetails:) forControlEvents:UIControlEventTouchUpInside];
            //annotationView.rightCalloutAccessoryView = rightButton;
        } else {
            annotationView.annotation = annotation;
        }
        
        //UIButton *button = (UIButton *)annotationView.rightCalloutAccessoryView;
        //button.tag = [locations indexOfObject:(Location *)annotation];
        
        return annotationView;
    }
    
    return nil;
}

@end
