//
//  CatchSizeDetailViewController.m
//  FishTally
//
//  Created by Mark Winkler on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CatchSizeDetailViewController.h"
#import "CatchSize.h"

@interface CatchSizeDetailViewController ()

@end

@implementation CatchSizeDetailViewController{
    NSString *catchSizeName;
    double multiplier;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize catchSizeToEdit = _catchSizeToEdit;
@synthesize nameTextField = _nameTextField;
@synthesize multiplierLabel = _multiplierLabel;
@synthesize multiplierStepper = _multiplierStepper;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        catchSizeName = @"";
        multiplier = 1.0f;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setCatchSizeToEdit:(CatchSize *)newCatchSizeToEdit
{
    if (_catchSizeToEdit != newCatchSizeToEdit) {
        _catchSizeToEdit = newCatchSizeToEdit;
        
        catchSizeName = _catchSizeToEdit.name;
    }
}

- (void)applicationDidEnterBackground
{    
    [self.nameTextField resignFirstResponder];
}

- (void)toggleSaveButtonWithText:(NSString *)text
{
    if ([text length] > 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.catchSizeToEdit != nil) {
        self.title = @"Edit Size";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(done:)];
        catchSizeName = self.catchSizeToEdit.name;
        multiplier = [self.catchSizeToEdit.multiplier doubleValue];
    } else {
        [self.nameTextField becomeFirstResponder];
    }
    
    self.nameTextField.text = catchSizeName;
    self.multiplierStepper.value = multiplier;
    self.multiplierLabel.text = [NSString stringWithFormat:@"%.1f %@", multiplier, NSLocalizedString(@"x catch points", nil)];
    [self toggleSaveButtonWithText:catchSizeName];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(hideKeyboard:)];
    
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.nameTextField = nil;
    self.multiplierStepper = nil;
    self.multiplierLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.nameTextField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    catchSizeName = newText;
    [self toggleSaveButtonWithText:catchSizeName];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    catchSizeName = theTextField.text;
    [self toggleSaveButtonWithText:catchSizeName];
}

- (void)hideKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    if (indexPath != nil && indexPath.section == 0 && indexPath.row == 0) {
        return;
    }
    
    [self.nameTextField resignFirstResponder];
}

- (int)nextSegmentedControlId
{
    int segmentedControlId = [[NSUserDefaults standardUserDefaults] integerForKey:@"SegmentedControlID"];
    [[NSUserDefaults standardUserDefaults] setInteger:segmentedControlId+1 forKey:@"SegmentedControlID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return segmentedControlId;
}

#pragma mark - point stepper values

- (IBAction)changePointMultiplierStepper:(UIStepper *)sender {
    double value = (double)[sender value];
    multiplier = value;
    self.multiplierLabel.text = [NSString stringWithFormat:@"%.1f %@", multiplier, NSLocalizedString(@"x catch points", nil)];
}

- (void)closeScreen
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender
{    
    CatchSize *catchSize = nil;
    if (self.catchSizeToEdit != nil) {
        catchSize = self.catchSizeToEdit;
    } else {
        catchSize = [NSEntityDescription insertNewObjectForEntityForName:@"CatchSize" inManagedObjectContext:self.managedObjectContext];
        catchSize.segmentedControlId = [NSNumber numberWithInt:[self nextSegmentedControlId]];
    }
    catchSize.name = catchSizeName;
    catchSize.multiplier = [NSNumber numberWithFloat:multiplier];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        FATAL_CORE_DATA_ERROR(error);
        return;
    }
    
    [self closeScreen];
}

- (IBAction)cancel:(id)sender
{
    [self closeScreen];
}
@end
