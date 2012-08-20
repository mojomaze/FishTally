//
//  Location.m
//  FishTally
//
//  Created by Mark Winkler on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize name = _name;
@synthesize detail = _detail;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize latitudeDelta = _latitudeDelta;
@synthesize longitudeDelta = _longitudeDelta;

# pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return self.detail;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    self.latitude = [NSNumber numberWithDouble:newCoordinate.latitude];
    self.longitude = [NSNumber numberWithDouble:newCoordinate.longitude];
}

- (BOOL)validRegion
{
    if ([self.latitudeDelta doubleValue] != 0 && [self.longitudeDelta doubleValue] != 0) {
        if ([self.longitude doubleValue] != 0 && [self.latitude doubleValue] != 0) {
            return YES;
        }
    }
    return NO;
}

- (MKCoordinateRegion)region {
    MKCoordinateRegion region;
    region.center = self.coordinate;
    MKCoordinateSpan span;
    span.latitudeDelta =  [self.latitudeDelta doubleValue];
    span.longitudeDelta = [self.longitudeDelta doubleValue];
    region.span = span;
    return region;
}

@end
