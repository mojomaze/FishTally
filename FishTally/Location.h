//
//  Location.h
//  FishTally
//
//  Created by Mark Winkler on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *latitudeDelta;
@property (nonatomic, strong) NSNumber *longitudeDelta;
@property (nonatomic, strong) CLPlacemark *placemark;

@end
