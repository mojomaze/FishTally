//
//  LurePickerViewController.h
//  FishTally
//
//  Created by Mark Winkler on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class LurePickerViewController, Lure;

#import <UIKit/UIKit.h>

@protocol LurePickerViewDelegate <NSObject>
- (void)lurePicker:(LurePickerViewController *)picker didPickLure:(Lure *)lure;
@end

@interface LurePickerViewController : UITableViewController

@property (nonatomic, weak) id <LurePickerViewDelegate> delegate;
@property (nonatomic, strong) Lure *selectedLure;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
