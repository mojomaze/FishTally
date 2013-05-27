//
//  FamilyPickerViewController.h
//  FishTally
//
//  Created by Mark Winkler on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FamilyPickerViewController, FishFamily;

@protocol FamilyPickerViewDelegate <NSObject>
- (void)familyPicker:(FamilyPickerViewController *)picker didPickFamily:(FishFamily *)selectedFishFamily;
@end

@interface FamilyPickerViewController : UITableViewController

@property (nonatomic, weak) id <FamilyPickerViewDelegate> delegate;
@property (nonatomic, strong) FishFamily *selectedFamily;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
