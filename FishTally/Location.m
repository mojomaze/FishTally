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
@synthesize placemark = _placemark;

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


@end
