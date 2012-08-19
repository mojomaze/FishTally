//
//  GameDetailViewController.m
//  FishTally
//
//  Created by Mark Winkler on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameDetailViewController.h"
#import "Game.h"
#import "GameLocationViewController.h"
#import "Location.h"

@implementation GameDetailViewController {
    NSString *name;
    double latitude;
    double longitude;
    double latitudeDelta;
    double longitudeDelta;
    CLPlacemark *placemark;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize gameToEdit = _gameToEdit;
@synthesize nameTextField = _nameTextField;

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

- (void)toggleSaveButton
{
    if ([name length] > 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.gameToEdit != nil) {
        self.title = @"Edit Game";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(done:)];
        name = self.gameToEdit.name;
        latitude = [self.gameToEdit.latitude doubleValue];
        longitude = [self.gameToEdit.longitude doubleValue];
        latitudeDelta = [self.gameToEdit.latitudeDelta doubleValue];
        longitudeDelta = [self.gameToEdit.longitudeDelta doubleValue];
        placemark = self.gameToEdit.placemark;
        
        self.nameTextField.text = name;
    }
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(hideKeyboard:)];
    
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    [self toggleSaveButton];
    [self.nameTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.nameTextField = nil;
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
    name = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    [self toggleSaveButton];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    name = theTextField.text;
    [self toggleSaveButton];
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

- (void)closeScreen
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender
{
    Game *game = nil;
    if (self.gameToEdit != nil) {
        game = self.gameToEdit;
    } else {
        game = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:self.managedObjectContext];
        game.date = [NSDate date];
    }
    game.name = self.nameTextField.text;
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditLocation"]) {
        GameLocationViewController *controller = segue.destinationViewController;
        Location *location = [[Location alloc] init];
        if (self.gameToEdit != nil) {
            location.latitude = self.gameToEdit.latitude;
            location.longitude = self.gameToEdit.longitude;
            location.latitudeDelta = self.gameToEdit.latitudeDelta;
            location.longitudeDelta = self.gameToEdit.longitudeDelta;
            location.placemark = self.gameToEdit.placemark;
            location.name = self.gameToEdit.name;
            location.detail = self.gameToEdit.dateString;
        }
        controller.location = location;
        controller.delegate = self;
    }
}

#pragma mark - GameLocationDelegate

- (void) locationController:(GameLocationViewController *)controller didSetLocation:(Location *)location {
    latitude = [location.latitude doubleValue];
    longitude = [location.longitude doubleValue];
    latitudeDelta = [location.latitudeDelta doubleValue];
    latitudeDelta = [location.latitudeDelta doubleValue];
    placemark = location.placemark;
}

@end
