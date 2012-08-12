//
//  LureCategoriesViewController.h
//  FishTally
//
//  Created by Mark Winkler on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsListViewDelegate.h"

@interface LureCategoriesViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id <SettingsListViewDelegate> delegate;

@end
