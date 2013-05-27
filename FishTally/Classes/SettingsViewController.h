//
//  SettingsViewController.h
//  FishTally
//
//  Created by Mark Winkler on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsListViewDelegate.h"
#import "UnitsPickerViewController.h"

@interface SettingsViewController : UITableViewController 
<
SettingsListViewDelegate,
UnitsPickerDelegate
>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
