//
//  FishDetailViewController.h
//  FishTally
//
//  Created by Mark Winkler on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyPickerViewController.h"

@class Fish;

@interface FishDetailViewController : UITableViewController
<
UITextFieldDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
FamilyPickerViewDelegate
>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UILabel *photoLabel;
@property (nonatomic, strong) IBOutlet UILabel *pointLabel;
@property (nonatomic, strong) IBOutlet UIStepper *pointStepper;
@property (nonatomic, strong) Fish *fishToEdit;
@property (nonatomic, strong) IBOutlet UILabel *familyLabel;

- (IBAction)changePointStepper:(UIStepper *)sender;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
