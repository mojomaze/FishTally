//
//  FishDetailViewController.m
//  FishTally
//
//  Created by Mark Winkler on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FishDetailViewController.h"
#import "Fish.h"
#import "FamilyPickerViewController.h"

@interface FishDetailViewController()
- (void)showPhotoMenu;
- (void)showImage:(UIImage *)theImage;
@end

@implementation FishDetailViewController {
    NSString *fishName;
    int smallPoints;
    int largePoints;
    UIImage *image;
    UIActionSheet *actionSheet;
    UIImagePickerController *imagePicker;
    NSString *family;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fishToEdit = _fishToEdit;
@synthesize nameTextField = _nameTextField;
@synthesize photoImageView = _photoImageView;
@synthesize photoLabel = _photoLabel;
@synthesize smallPointLabel = _smallPointLabel;
@synthesize smallPointStepper = _smallPointStepper;
@synthesize largePointLabel = _largePointLabel;
@synthesize largePointStepper = _largePointStepper;
@synthesize familyLabel = _familyLabel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        fishName = @"";
        smallPoints = 0;
        largePoints = 0;
        family = @"No Family";
        
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

- (void)setFishToEdit:(Fish *)newFishToEdit
{
    if (_fishToEdit != newFishToEdit) {
        _fishToEdit = newFishToEdit;
        
        fishName = _fishToEdit.name;
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
    
    [self.nameTextField resignFirstResponder];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.fishToEdit != nil) {
        self.title = @"Edit Fish";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(done:)];
        if ([self.fishToEdit hasPhoto] && image == nil) {
            UIImage *existingImage = [self.fishToEdit photoImage];
            if (existingImage != nil) {
                [self showImage:existingImage];
            }
        }
        smallPoints = [self.fishToEdit.smallPointValue intValue];
        largePoints = [self.fishToEdit.largePointValue intValue];
        family = self.fishToEdit.family;

    } else {
        [self.nameTextField becomeFirstResponder];
    }
    
    if (image != nil) {
        [self showImage:image];
    }
    
    self.nameTextField.text = fishName;
    self.smallPointStepper.value = smallPoints;
    self.largePointStepper.value = largePoints;
    self.smallPointLabel.text = [NSString stringWithFormat:@"%d %@", smallPoints, NSLocalizedString(@"points", nil)];
    self.largePointLabel.text = [NSString stringWithFormat:@"%d %@", largePoints, NSLocalizedString(@"points", nil)];
    self.familyLabel.text = family;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(hideKeyboard:)];
    
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.nameTextField = nil;
    self.photoImageView = nil;
    self.smallPointStepper = nil;
    self.smallPointLabel = nil;
    self.largePointStepper = nil;
    self.largePointLabel = nil;
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
    if (indexPath.section == 2 && indexPath.row == 0 && !self.photoImageView.hidden) {
        return self.photoImageView.frame.size.height+20;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.nameTextField becomeFirstResponder];
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self showPhotoMenu];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PickFamily"]) {
        FamilyPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.selectedFamilyName = family;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    fishName = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    fishName = theTextField.text;
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

#pragma mark - point stepper values

- (IBAction)changeSmallPointStepper:(UIStepper *)sender {
    double value = (double)[sender value];
    smallPoints = value;
    self.smallPointLabel.text = [NSString stringWithFormat:@"%d %@", smallPoints, NSLocalizedString(@"points", nil)];
}

- (IBAction)changeLargePointStepper:(UIStepper *)sender {
    double value = (double)[sender value];
    largePoints = value;
    self.largePointLabel.text = [NSString stringWithFormat:@"%d %@", largePoints, NSLocalizedString(@"points", nil)];
}

- (void)closeScreen
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (int)nextPhotoId
{
    int photoId = [[NSUserDefaults standardUserDefaults] integerForKey:@"FishPhotoID"];
    [[NSUserDefaults standardUserDefaults] setInteger:photoId+1 forKey:@"FishPhotoID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return photoId;
}

- (IBAction)done:(id)sender
{
    Fish *fish = nil;
    if (self.fishToEdit != nil) {
        fish = self.fishToEdit;
    } else {
        fish = [NSEntityDescription insertNewObjectForEntityForName:@"Fish" inManagedObjectContext:self.managedObjectContext];
        fish.photoId = [NSNumber numberWithInt:-1];
    }
    fish.name = fishName;
    fish.smallPointValue = [NSNumber numberWithFloat:smallPoints];
    fish.largePointValue = [NSNumber numberWithFloat:largePoints];
    fish.family = family;
    
    if (image != nil) {
        if (![fish hasPhoto]) {
            fish.photoId = [NSNumber numberWithInt:[self nextPhotoId]];
        }
        
        NSData *data = UIImagePNGRepresentation(image);
        NSError *error;
        if (![data writeToFile:[fish photoPath] options:NSDataWritingAtomic error:&error]) {
            NSLog(@"Error writing file: %@", error);
        }
    }
    
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

#pragma mark - FamilyPickerViewDelegate

- (void)familyPicker:(FamilyPickerViewController *)picker didPickFamily:(NSString *)familyName {
    family = familyName;
    self.familyLabel.text = family;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
