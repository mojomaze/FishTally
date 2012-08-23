//
//  CatchDislayViewController.h
//  FishTally
//
//  Created by Mark Winkler on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Catch;

@interface CatchDislayViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *fishImageView;
@property (nonatomic, strong) IBOutlet UIImageView *lureImageView;
@property (nonatomic, strong) IBOutlet UILabel *fishLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *sizeLabel;
@property (nonatomic, strong) IBOutlet UILabel *locationLabel;
@property (nonatomic, strong) IBOutlet UILabel *lureLabel;
@property (nonatomic, strong) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) Catch *catch;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)edit:(id)sender;

@end
