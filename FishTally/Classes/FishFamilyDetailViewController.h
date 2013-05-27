//
//  FishFamilyDetailViewController.h
//  FishTally
//
//  Created by Mark Winkler on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FishFamily;

@interface FishFamilyDetailViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) FishFamily *fishFamilyToEdit;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;

-(IBAction)done:(id)sender;
-(IBAction)cancel:(id)sender;

@end
