//
//  LureDetailViewController.m
//  FishTally
//
//  Created by Mark Winkler on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LureDetailViewController.h"
#import "Lure.h"
#import "CategoryPickerViewController.h"
#import "LureType.h"

@interface LureDetailViewController()
- (void)showPhotoMenu;
- (void)showImage:(UIImage *)theImage;
@end

@implementation LureDetailViewController {
    NSString *lureName;
    double multiplier;
    UIImage *image;
    UIActionSheet *actionSheet;
    UIImagePickerController *imagePicker;
    NSString *category;
    LureType *lureType;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize lureToEdit = _lureToEdit;
@synthesize nameTextField = _nameTextField;
@synthesize photoImageView = _photoImageView;
@synthesize photoLabel = _photoLabel;
@synthesize multiplierLabel = _multiplierLabel;
@synthesize multiplierStepper = _multiplierStepper;
@synthesize categoryLabel = _categoryLabel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        lureName = @"";
        multiplier = 1.0f;
        category = @"No Category";
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

- (void)setLureToEdit:(Lure *)newLureToEdit
{
    if (_lureToEdit != newLureToEdit) {
        _lureToEdit = newLureToEdit;
        
        lureName = _lureToEdit.name;
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
    
    if (self.lureToEdit != nil) {
        self.title = @"Edit Lure";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(done:)];
        if ([self.lureToEdit hasPhoto] && image == nil) {
            UIImage *existingImage = [self.lureToEdit photoImage];
            if (existingImage != nil) {
                [self showImage:existingImage];
            }
        }
        multiplier = [self.lureToEdit.multiplier doubleValue];
        category = self.lureToEdit.lureCategory;
        lureType = self.lureToEdit.lureType;
    } else {
        [self.nameTextField becomeFirstResponder];
    }
    
    if (image != nil) {
        [self showImage:image];
    }
    
    self.nameTextField.text = lureName;
    self.categoryLabel.text = category;
    self.multiplierStepper.value = multiplier;
    self.multiplierLabel.text = [NSString stringWithFormat:@"%.1f %@", multiplier, NSLocalizedString(@"x catch points", nil)];
    
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
    self.multiplierStepper = nil;
    self.multiplierLabel = nil;
    self.categoryLabel = nil;
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    lureName = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    lureName = theTextField.text;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PickCategory"]) {
        CategoryPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.managedObjectContext = self.managedObjectContext;
        controller.selectedCategory = lureType;
    }
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

- (int)nextPhotoId
{
    int photoId = [[NSUserDefaults standardUserDefaults] integerForKey:@"LurePhotoID"];
    [[NSUserDefaults standardUserDefaults] setInteger:photoId+1 forKey:@"LurePhotoID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return photoId;
}

- (IBAction)done:(id)sender
{
    // lureType is required
    if (lureType == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete"
                                                        message:@"Add category"
                                                       delegate: self
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil ];
        [alert show];
        return;
    }    

    
    Lure *lure = nil;
    if (self.lureToEdit != nil) {
        lure = self.lureToEdit;
    } else {
        lure = [NSEntityDescription insertNewObjectForEntityForName:@"Lure" inManagedObjectContext:self.managedObjectContext];
        lure.photoId = [NSNumber numberWithInt:-1];
    }
    lure.name = lureName;
    lure.multiplier = [NSNumber numberWithFloat:multiplier];
    lure.lureType = lureType;
    
    if (image != nil) {
        if (![lure hasPhoto]) {
            lure.photoId = [NSNumber numberWithInt:[self nextPhotoId]];
        }
        
        NSData *data = UIImagePNGRepresentation(image);
        NSError *error;
        if (![data writeToFile:[lure photoPath] options:NSDataWritingAtomic error:&error]) {
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

#pragma mark - CategoryPickerViewDelegate

- (void) categoryPicker:(CategoryPickerViewController *)picker didPickLureType:(LureType *)selectedLureType {
    lureType = selectedLureType;
    category = selectedLureType.name;
    self.categoryLabel.text = category;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
