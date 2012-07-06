//
//  FishDetailViewController.h
//  FishTally
//
//  Created by Mark Winkler on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class Fish;

#import <UIKit/UIKit.h>

@interface FishDetailViewController : UITableViewController
<
UITextFieldDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate
>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UILabel *photoLabel;
@property (nonatomic, strong) IBOutlet UILabel *smallPointLabel;
@property (nonatomic, strong) IBOutlet UIStepper *smallPointStepper;
@property (nonatomic, strong) IBOutlet UILabel *largePointLabel;
@property (nonatomic, strong) IBOutlet UIStepper *largePointStepper;
@property (nonatomic, strong) Fish *fishToEdit;

- (IBAction)changeSmallPointStepper:(UIStepper *)sender;
- (IBAction)changeLargePointStepper:(UIStepper *)sender;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
