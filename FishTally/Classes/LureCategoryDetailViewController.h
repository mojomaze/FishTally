//
//  LureCategoryDetailViewController.h
//  FishTally
//
//  Created by Mark Winkler on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LureType;

@interface LureCategoryDetailViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) LureType *lureCategoryToEdit;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;

-(IBAction)done:(id)sender;
-(IBAction)cancel:(id)sender;

@end
