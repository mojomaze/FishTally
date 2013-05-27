//
//  GameDetailViewController.h
//  FishTally
//
//  Created by Mark Winkler on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationDetailViewController.h"

@class Game;

@interface GameDetailViewController : UITableViewController 
<
    UITextFieldDelegate,
    LocationDetailDelegate
>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Game *gameToEdit;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UILabel *locationLabel;
           
-(IBAction)done:(id)sender;
-(IBAction)cancel:(id)sender;

@end
