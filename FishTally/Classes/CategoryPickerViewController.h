//
//  CategoryPickerViewController.h
//  FishTally
//
//  Created by Mark Winkler on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryPickerViewController, LureType;

@protocol CategoryPickerViewDelegate <NSObject>
- (void)categoryPicker:(CategoryPickerViewController *)picker didPickLureType:(LureType *)selectedLureType;
@end

@interface CategoryPickerViewController : UITableViewController

@property (nonatomic, weak) id <CategoryPickerViewDelegate> delegate;
@property (nonatomic, strong) LureType *selectedCategory;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end
