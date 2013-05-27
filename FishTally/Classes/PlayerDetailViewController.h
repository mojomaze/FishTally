//
//  PlayerDetailViewController.h
//  FishTally
//
//  Created by Mark Winkler on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LurePickerViewController.h"

@class Player, Game;

@interface PlayerDetailViewController : UITableViewController 
<
    UITextFieldDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIActionSheetDelegate,
    LurePickerViewDelegate
>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Player *playerToEdit;
@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UILabel *photoLabel;
@property (nonatomic, strong) IBOutlet UILabel *lureLabel;

-(IBAction)done:(id)sender;
-(IBAction)cancel:(id)sender;

@end
