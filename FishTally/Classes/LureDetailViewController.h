//
//  LureDetailViewController.h
//  FishTally
//
//  Created by Mark Winkler on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryPickerViewController.h"

@class Lure;

@interface LureDetailViewController : UITableViewController
<
UITextFieldDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
CategoryPickerViewDelegate
>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UILabel *photoLabel;
@property (nonatomic, strong) IBOutlet UILabel *multiplierLabel;
@property (nonatomic, strong) IBOutlet UIStepper *multiplierStepper;
@property (nonatomic, strong) Lure *lureToEdit;
@property (nonatomic, strong) IBOutlet UILabel *categoryLabel;

- (IBAction)changePointMultiplierStepper:(UIStepper *)sender;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
