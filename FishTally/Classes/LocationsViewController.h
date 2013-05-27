//
//  LocationsViewController.h
//  FishTally
//
//  Created by Mark Winkler on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationsViewController : UIViewController <MKMapViewDelegate>;

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
