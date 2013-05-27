//
//  FishViewController.h
//  FishTally
//
//  Created by Mark Winkler on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsListViewDelegate.h"

@interface FishViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) id <SettingsListViewDelegate> delegate;

@end
