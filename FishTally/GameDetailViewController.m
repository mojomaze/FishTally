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
    BOOL performingReverseGeocoding;
    CLGeocoder *geocoder;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize gameToEdit = _gameToEdit;
@synthesize nameTextField = _nameTextField;
@synthesize locationLabel = _locationLabel;

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
    if ([name length] > 0 && !performingReverseGeocoding) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

- (void)updateLocationLabel {
    if (placemark != nil) {
        if (placemark.locality != nil) {
            if (placemark.administrativeArea != nil) {
                self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];
                return;
            }
            self.locationLabel.text = placemark.locality;
            return;
        }
        // no locality - just use lat and long
        self.locationLabel.text = [NSString stringWithFormat:@"%.1f, %.1f", latitude, longitude];
    } else {
        self.locationLabel.text = @"Add Location";
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //init name to blank to detect for location
    name = @"";

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
        [self updateLocationLabel];
    } else {
        [self.nameTextField becomeFirstResponder];
    }
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(hideKeyboard:)];
    
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    [self toggleSaveButton];
    
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
    game.placemark = placemark;
    game.latitude = [NSNumber numberWithDouble:latitude];
    game.longitude = [NSNumber numberWithDouble:longitude];
    game.latitudeDelta = [NSNumber numberWithDouble:latitudeDelta];
    game.longitudeDelta = [NSNumber numberWithDouble:longitudeDelta];
    
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
        location.latitude = [NSNumber numberWithDouble:latitude];
        location.longitude = [NSNumber numberWithDouble:longitude];
        location.latitudeDelta = [NSNumber numberWithDouble:latitudeDelta];
        location.longitudeDelta = [NSNumber numberWithDouble:longitudeDelta];
        if ([name isEqualToString:@""]) {
            location.name = @"New Game";
        } else {
            location.name = name;
        }
        
        if (self.gameToEdit) {
            location.detail = self.gameToEdit.dateString;
        }
        controller.location = location;
        controller.delegate = self;
    }
}

- (void)reverseGeocodeLocation:(Location *)location {
    if (!performingReverseGeocoding) {
        NSLog(@"*** Going to geocode");
        performingReverseGeocoding = YES;
        [self toggleSaveButton];
        
        if (!geocoder) {
            geocoder = [[CLGeocoder alloc] init];
        }
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:[location.latitude doubleValue] longitude:[location.longitude doubleValue]];
        
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"*** Found placemarks: %@, error: %@", placemarks, error);
            
            
            if (error == nil && [placemarks count] > 0) {
                placemark = [placemarks lastObject];
            } else {
                placemark = nil;
            }
            
            performingReverseGeocoding = NO;
            [self updateLocationLabel];
            [self toggleSaveButton];
        }];
    }

}

#pragma mark - GameLocationDelegate

- (void) locationController:(GameLocationViewController *)controller didSetLocation:(Location *)location {
    latitude = [location.latitude doubleValue];
    longitude = [location.longitude doubleValue];
    latitudeDelta = [location.latitudeDelta doubleValue];
    longitudeDelta = [location.longitudeDelta doubleValue];
    if (location.latitude != nil && location.latitude != nil) {
        [self reverseGeocodeLocation:location];
    } else {
        placemark = nil;
        [self updateLocationLabel];
    }
}

@end
