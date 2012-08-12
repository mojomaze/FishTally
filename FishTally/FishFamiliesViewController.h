//
//  FishFamiliesViewController.h
//  FishTally
//
//  Created by Mark Winkler on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsListViewDelegate.h"

@interface FishFamiliesViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id <SettingsListViewDelegate> delegate;

@end
