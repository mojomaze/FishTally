//
//  CatchSizeDetailViewController.h
//  FishTally
//
//  Created by Mark Winkler on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CatchSize;

@interface CatchSizeDetailViewController : UITableViewController
<
UITextFieldDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate
>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UILabel *multiplierLabel;
@property (nonatomic, strong) IBOutlet UIStepper *multiplierStepper;
@property (nonatomic, strong) CatchSize *catchSizeToEdit;

- (IBAction)changePointMultiplierStepper:(UIStepper *)sender;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
