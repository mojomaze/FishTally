//
//  CatchDetailViewController.m
//  FishTally
//
//  Created by Mark Winkler on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CatchDetailViewController.h"
#import "Catch.h"
#import "Player.h"
#import "Lure.h"
#import "Fish.h"
#import "CatchSize.h"
#import "Location.h"
#import "LocationDetailViewController.h"
#import "Game.h"
#import "SizeDetailViewController.h"

@interface CatchDetailViewController()
- (void)showPhotoMenu;
- (void)showImage:(UIImage *)theImage;
- (void)displayCatchPointValue;
- (void)calculateScore;
@end

@implementation CatchDetailViewController {
    NSString *fishName;
    NSString *lureName;
    double score;
    UIImage *image;
    UIActionSheet *actionSheet;
    UIImagePickerController *imagePicker;
    double size;
    Lure *catchLure;
    Fish *catchFish;
    NSMutableArray *sizeNames;
    NSMutableArray *sizeMultipliers;
    double latitude;
    double longitude;
    double latitudeDelta;
    double longitudeDelta;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize catchToEdit = _catchToEdit;
@synthesize player = _player;
@synthesize fishLabel = _fishLabel;
@synthesize pointsLabel = _pointsLabel;
@synthesize photoImageView = _photoImageView;
@synthesize lureLabel = _lureLabel;
@synthesize photoLabel = _photoLabel;
@synthesize sizeControl = _sizeControl;
@synthesize locationLabel = _locationLabel;
@synthesize sizeLabel = _sizeLabel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        fishName = @"No Fish";
        lureName = @"No Lure";
        score = 0.0f;
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

- (void)setCatchToEdit:(Catch *)newCatchToEdit
{
    if (_catchToEdit != newCatchToEdit) {
        _catchToEdit = newCatchToEdit;
        
        if (_catchToEdit.fish != nil) {
            fishName = _catchToEdit.fish.name;
        }
        if (_catchToEdit.lure != nil) {
            lureName = _catchToEdit.lure.name;
        }
        score = [_catchToEdit.score doubleValue];
    }
}

- (void)applicationDidEnterBackground
{
    if (imagePicker != nil) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        imagePicker = nil;
    }
    
    if (actionSheet != nil) {
        [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
        actionSheet = nil;
    }
}

- (void)initSizeControl {
    // get sizes and multipliers
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CatchSize" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"segmentedControlId" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error;
    NSArray *sizes = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    sizeNames = [[NSMutableArray alloc] init];
    sizeMultipliers = [[NSMutableArray alloc] init];
    
    if ([sizes count] > 1) {
        for (CatchSize *catchSize in sizes) {
            [sizeNames addObject:catchSize.name];
            [sizeMultipliers addObject:catchSize.multiplier];
        }
    } else { // add a single default size
        [sizeNames addObject:@"Small Fry"];
        [sizeMultipliers addObject:[NSNumber numberWithFloat:1.0f]];
        [sizeNames addObject:@"Whopper"];
        [sizeMultipliers addObject:[NSNumber numberWithFloat:1.5f]];
    }
    
    [self.sizeControl removeAllSegments];
    
    for (int i = 0; i < [sizeNames count]; i++) {
        [self.sizeControl insertSegmentWithTitle:[sizeNames objectAtIndex:i] atIndex:i animated:NO];
    }
}

- (void)updateLocationlabel {
    if (latitude != 0 && longitude != 0) {
        self.locationLabel.text = [NSString stringWithFormat:@"%.1f, %.1f", latitude, longitude];
    } else {
        self.locationLabel.text = @"Add Location";
    }
}

- (void)updateSizeLabel {
    if (size > 0) {
        self.sizeLabel.text = [NSString stringWithFormat:@"%.1f in", size];
    } else {
        self.sizeLabel.text = @"Add Size";
    }
}

- (void)toggleSaveButton
{
    if (catchFish != nil && catchLure != nil) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initSizeControl];
    
    if (self.catchToEdit != nil) {
        self.title = @"Edit Catch";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(done:)];
        if ([self.catchToEdit hasPhoto] && image == nil) {
            UIImage *existingImage = [self.catchToEdit photoImage];
            if (existingImage != nil) {
                [self showImage:existingImage];
            }
        }
        
        catchFish = self.catchToEdit.fish;
        if (catchFish != nil) {
            fishName = catchFish.name;
        }
        
        catchLure = self.catchToEdit.lure;
        if (catchFish != nil) {
            lureName= catchLure.name;
        }
        size = [self.catchToEdit.size doubleValue];
        
        latitude = [self.catchToEdit.latitude doubleValue];
        longitude = [self.catchToEdit.longitude doubleValue];
        latitudeDelta = [self.catchToEdit.latitudeDelta doubleValue];
        longitudeDelta = [self.catchToEdit.longitudeDelta doubleValue];
        [self updateLocationlabel];
        
    } else {
        if (self.player.lure != nil) {
            catchLure = self.player.lure;
            lureName = catchLure.name;
            // default size to first segment
            size = 0;;
        }
    }
    
    if (image != nil) {
        [self showImage:image];
    }
    
    self.fishLabel.text = fishName;
    self.lureLabel.text = lureName;
    self.sizeControl.selectedSegmentIndex = size;
    [self displayCatchPointValue];
    [self toggleSaveButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.fishLabel = nil;
    self.lureLabel = nil;
    self.photoImageView = nil;
    self.pointsLabel = nil;
    self.sizeControl = nil;
    self.locationLabel = nil;
    self.sizeLabel = nil;
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

- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4 && indexPath.row == 0 && !self.photoImageView.hidden) {
        return self.photoImageView.frame.size.height+20;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4 && indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self showPhotoMenu];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PickLure"]) {
        LurePickerViewController *controller = segue.destinationViewController;
        controller.managedObjectContext = self.managedObjectContext;
        controller.delegate = self;
        controller.selectedLure = catchLure;
    }
    
    if ([segue.identifier isEqualToString:@"PickFish"]) {
        FishPickerViewController *controller = segue.destinationViewController;
        controller.managedObjectContext = self.managedObjectContext;
        controller.delegate = self;
        controller.selectedFish = catchFish;
    }
    
    if ([segue.identifier isEqualToString:@"EditLocation"]) {
        LocationDetailViewController *controller = segue.destinationViewController;
        Location *location = [[Location alloc] init];
        Game *game = self.player.game;
        
        if (latitude == 0 && longitude == 0) {
            // use the game coordinates if catch not set
            location.latitude = game.latitude;
            location.longitude = game.longitude;
        } else {
            location.latitude = [NSNumber numberWithDouble:latitude];
            location.longitude = [NSNumber numberWithDouble:longitude];
        }
        
        if (latitudeDelta == 0 && longitudeDelta == 0) {
            // use the game delta if catch is not set
            location.latitudeDelta = game.latitudeDelta;
            location.longitudeDelta = game.longitudeDelta;
        } else {
            location.latitudeDelta = [NSNumber numberWithDouble:latitudeDelta];
            location.longitudeDelta = [NSNumber numberWithDouble:longitudeDelta];
        }
        
        if (fishName != nil) {
            location.name = fishName;
        } else {
            location.name = @"New Catch";
        }
        
        location.detail = [NSString stringWithFormat:NSLocalizedString(@"%.1f points", nil), score];
        controller.location = location;
        controller.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"EditSize"]) {
        SizeDetailViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.size = [NSNumber numberWithDouble:size];
    }
}

- (void)closeScreen
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (int)nextPhotoId
{
    int photoId = [[NSUserDefaults standardUserDefaults] integerForKey:@"CatchPhotoID"];
    [[NSUserDefaults standardUserDefaults] setInteger:photoId+1 forKey:@"CatchPhotoID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return photoId;
}

- (IBAction)done:(id)sender
{
    // fish and lure are required
    if (catchFish == nil || catchLure == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete"
                                                        message:@"Add fish and lure"
                                                       delegate: self
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil ];
        [alert show];
        return;
    }    
    
    Catch *catch = nil;
    if (self.catchToEdit != nil) {
        catch = self.catchToEdit;
    } else {
        catch = [NSEntityDescription insertNewObjectForEntityForName:@"Catch" inManagedObjectContext:self.managedObjectContext];
        catch.photoId = [NSNumber numberWithInt:-1];
        catch.date = [NSDate date];
    }
    catch.fish = catchFish;
    catch.lure = catchLure;
    catch.score = [NSNumber numberWithDouble:score];
    catch.size = [NSNumber numberWithInt:size];
    
    if (image != nil) {
        if (![catch hasPhoto]) {
            catch.photoId = [NSNumber numberWithInt:[self nextPhotoId]];
        }
        
        NSData *data = UIImagePNGRepresentation(image);
        NSError *error;
        if (![data writeToFile:[catch photoPath] options:NSDataWritingAtomic error:&error]) {
            NSLog(@"Error writing file: %@", error);
        }
    }
    
    // update or add Fish
    if (catch.fish != nil) {
        [catch.fish removeCatchesObject:catch];
    }
    catch.fish = catchFish;
    
    if (catchFish != nil) {
        [catchFish addCatchesObject:catch];   
    }
    
    // update or add lure
    if (catch.lure != nil) {
        [catch.lure removeCatchesObject:catch];
    }
    catch.lure = catchLure;
    
    if (catchLure != nil) {
        [catchLure addCatchesObject:catch];   
    }
    catch.latitude = [NSNumber numberWithDouble:latitude];
    catch.longitude = [NSNumber numberWithDouble:longitude];
    catch.latitudeDelta = [NSNumber numberWithDouble:latitudeDelta];
    catch.longitudeDelta = [NSNumber numberWithDouble:longitudeDelta];
    
    [self.player addCatchesObject:catch];
    [self.player calculatePlayerScore];
    
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

- (void)takePhoto
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)choosePhotoFromLibrary
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showPhotoMenu
{
    //if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    if (YES) {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
        
        [actionSheet showInView:self.view];
    } else {
        [self choosePhotoFromLibrary];
    }
}

- (void)showImage:(UIImage *)theImage
{
    // get aspect ratio of image
    float aspectRatio = theImage.size.width / theImage.size.height;
    float height = 260 / aspectRatio;
    
    self.photoImageView.image = theImage;
    self.photoImageView.hidden = NO;
    self.photoImageView.frame = CGRectMake(10, 10, 260, lroundf(height));
    self.photoLabel.hidden = YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if ([self isViewLoaded]) {
        [self showImage:image];
        [self.tableView reloadData];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    imagePicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    imagePicker = nil;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)theActionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self choosePhotoFromLibrary];
    }
    actionSheet = nil;
}

-(void) updateCatchPointValue {
    [self calculateScore];
    [self displayCatchPointValue];
}

- (void)displayCatchPointValue {
    self.pointsLabel.text = [NSString stringWithFormat:@"%.1f", score];
}

- (void)calculateScore {
    float points;
    float sizeMultiplier;
    float lureMultiplier;
    
    // lure and fish are required
    if (catchFish && catchLure) {
        // TODO: REFACTOR REQUIRED
        points = [catchFish.points floatValue];
        sizeMultiplier = [[sizeMultipliers objectAtIndex:size] floatValue];
        lureMultiplier = [catchLure.multiplier floatValue];
        score = points * sizeMultiplier * lureMultiplier;
    } else {
        score = 0.0f;
    }
}

- (IBAction)changeCatchSize:(UISegmentedControl *)segmentedControl {
    size = segmentedControl.selectedSegmentIndex;
    [self updateCatchPointValue];
}

#pragma mark - LurePickerViewControllerDelegate
- (void)lurePicker:(LurePickerViewController *)picker didPickLure:(Lure *)lure
{
    catchLure = lure;
    self.lureLabel.text = catchLure.name;
    [self updateCatchPointValue];
    [self toggleSaveButton];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - LurePickerViewControllerDelegate
- (void)fishPicker:(FishPickerViewController *)picker didPickFish:(Fish *)fish
{
    catchFish = fish;
    self.fishLabel.text = catchFish.name;
    [self updateCatchPointValue];
    [self toggleSaveButton];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - LocationDetailDelegate

- (void) locationController:(LocationDetailViewController *)controller didSetLocation:(Location *)location {
    latitude = [location.latitude doubleValue];
    longitude = [location.longitude doubleValue];
    latitudeDelta = [location.latitudeDelta doubleValue];
    longitudeDelta = [location.longitudeDelta doubleValue];
    [self updateLocationlabel];
}

# pragma mark - SizeDetailDelegate

- (void) sizeController:(SizeDetailViewController *)controller didSetSize:(NSNumber *)newSize {
    size = [newSize doubleValue];
    [self updateSizeLabel];
}
     
@end