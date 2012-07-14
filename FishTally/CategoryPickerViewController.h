//
//  CategoryPickerViewController.h
//  FishTally
//
//  Created by Mark Winkler on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryPickerViewController;

@protocol CategoryPickerViewDelegate <NSObject>
- (void)categoryPicker:(CategoryPickerViewController *)picker didPickCategory:(NSString*)categoryName;
@end

@interface CategoryPickerViewController : UITableViewController

@property (nonatomic, weak) id <CategoryPickerViewDelegate> delegate;
@property (nonatomic, strong) NSString *selectedCategoryName;

@end
