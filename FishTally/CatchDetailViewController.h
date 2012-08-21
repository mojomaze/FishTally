//
//  CatchDetailViewController.h
//  FishTally
//
//  Created by Mark Winkler on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LurePickerViewController.h"
#import "FishPickerViewController.h"
#import "LocationDetailViewController.h"
#import "SizeDetailViewController.h"

@class Player, Catch;

@interface CatchDetailViewController : UITableViewController
<
    UITextFieldDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIActionSheetDelegate,
    UITextViewDelegate,
    LurePickerViewDelegate,
    FishPickerViewDelegate,
    LocationDetailDelegate,
    SizeDetailDelegate
>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) Catch *catchToEdit;
@property (nonatomic, strong) IBOutlet UILabel *fishLabel;
@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UILabel *photoLabel;
@property (nonatomic, strong) IBOutlet UILabel *lureLabel;
@property (nonatomic, strong) IBOutlet UILabel *pointsLabel;
@property (nonatomic, strong) IBOutlet UISegmentedControl *sizeControl;
@property (nonatomic, strong) IBOutlet UILabel *locationLabel;
@property (nonatomic, strong) IBOutlet UILabel *sizeLabel;
@property (nonatomic, strong) IBOutlet UITextView *textView;

- (IBAction)changeCatchSize: (UISegmentedControl *) segmentedControl;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;


@end
