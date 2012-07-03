//
//  GameDetailViewController.h
//  FishTally
//
//  Created by Mark Winkler on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class Game;

#import <UIKit/UIKit.h>

@interface GameDetailViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Game *gameToEdit;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
           
-(IBAction)done:(id)sender;
-(IBAction)cancel:(id)sender;

@end
