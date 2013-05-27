//
//  GameLocationViewController.h
//  FishTally
//
//  Created by Mark Winkler on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Location, LocationDetailViewController;

@protocol LocationDetailDelegate <NSObject>

- (void)locationController:(LocationDetailViewController *)controller didSetLocation:(Location *)location;

@end

@interface LocationDetailViewController : UIViewController <MKMapViewDelegate>;

@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) id <LocationDetailDelegate> delegate;

- (IBAction)toggleLocation:(id)sender;

@end
