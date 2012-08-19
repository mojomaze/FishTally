//
//  GameLocationViewController.h
//  FishTally
//
//  Created by Mark Winkler on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Location, GameLocationViewController;

@protocol GameLocationDelegate <NSObject>

- (void)locationController:(GameLocationViewController *)controller didSetLocation:(Location *)location;

@end

@interface GameLocationViewController : UIViewController <MKMapViewDelegate>;

@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UIToolbar *bottomToolbar;
@property (nonatomic, weak) id <GameLocationDelegate> delegate;

- (IBAction)toggleLocation:(id)sender;

@end
