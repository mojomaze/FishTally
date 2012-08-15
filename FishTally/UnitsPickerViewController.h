//
//  UnitsPickerViewController.h
//  FishTally
//
//  Created by Mark Winkler on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UnitsPickerViewController;

@protocol UnitsPickerDelegate <NSObject>
- (void) unitsPicker:(UnitsPickerViewController *)picker didPickUnits:(NSString *)units;
@end

@interface UnitsPickerViewController : UITableViewController

@property (nonatomic, weak) id <UnitsPickerDelegate> delegate;
@property (nonatomic, strong) NSString *selectedUnits;

@end
