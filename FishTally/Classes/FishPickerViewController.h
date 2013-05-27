//
//  FishPickerViewController.h
//  FishTally
//
//  Created by Mark Winkler on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class FishPickerViewController, Fish;

#import <UIKit/UIKit.h>

@protocol FishPickerViewDelegate <NSObject>
- (void)fishPicker:(FishPickerViewController *)picker didPickFish:(Fish *)fish;
@end

@interface FishPickerViewController : UITableViewController

@property (nonatomic, weak) id <FishPickerViewDelegate> delegate;
@property (nonatomic, strong) Fish *selectedFish;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

