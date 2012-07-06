//
//  PlayerDetailViewController.m
//  FishTally
//
//  Created by Mark Winkler on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import "Player.h"
#import "Game.h"
#import "Lure.h"

@interface PlayerDetailViewController()
- (void)showPhotoMenu;
- (void)showImage:(UIImage *)theImage;
@end

@implementation PlayerDetailViewController {
    NSString *playerName;
    NSString *defaultLureName;
    UIImage *image;
    UIActionSheet *actionSheet;
    UIImagePickerController *imagePicker;
    Lure *playerLure;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize playerToEdit = _playerToEdit;
@synthesize game = _game;
@synthesize nameTextField = _nameTextField;
@synthesize photoImageView = _photoImageView;
@synthesize lureLabel = _lureLabel;
@synthesize photoLabel = _photoLabel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        playerName = @"";
        defaultLureName = @"No Lure";
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

- (void)setPlayerToEdit:(Player *)newPlayerToEdit
{
    if (_playerToEdit != newPlayerToEdit) {
        _playerToEdit = newPlayerToEdit;
        
        playerName = _playerToEdit.name;
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
    
    if (self.playerToEdit != nil) {
        self.title = @"Edit Player";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(done:)];
        if ([self.playerToEdit hasPhoto] && image == nil) {
            UIImage *existingImage = [self.playerToEdit photoImage];
            if (existingImage != nil) {
                [self showImage:existingImage];
            }
        }
        
        playerLure = self.playerToEdit.lure;
        if (playerLure != nil) {
            defaultLureName = playerLure.name;
        }
    } else {
        [self.nameTextField becomeFirstResponder];
    }
    
    if (image != nil) {
        [self showImage:image];
    }
    
    self.nameTextField.text = playerName;
    self.lureLabel.text = defaultLureName;
    
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
    self.lureLabel = nil;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    if ([segue.identifier isEqualToString:@"PickLure"]) {
        LurePickerViewController *controller = segue.destinationViewController;
        controller.managedObjectContext = self.managedObjectContext;
        controller.delegate = self;
        controller.selectedLure = playerLure;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    playerName = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    playerName = theTextField.text;
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

- (int)nextPhotoId
{
    int photoId = [[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerPhotoID"];
    [[NSUserDefaults standardUserDefaults] setInteger:photoId+1 forKey:@"PlayerPhotoID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return photoId;
}

- (IBAction)done:(id)sender
{
    Player *player = nil;
    if (self.playerToEdit != nil) {
        player = self.playerToEdit;
    } else {
        player = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:self.managedObjectContext];
        player.photoId = [NSNumber numberWithInt:-1];
    }
    player.name = playerName;
    
    if (image != nil) {
        if (![player hasPhoto]) {
            player.photoId = [NSNumber numberWithInt:[self nextPhotoId]];
        }
        
        NSData *data = UIImagePNGRepresentation(image);
        NSError *error;
        if (![data writeToFile:[player photoPath] options:NSDataWritingAtomic error:&error]) {
            NSLog(@"Error writing file: %@", error);
        }
    }
    
    if (player.lure != nil) {
        [playerLure removePlayersObject:player];
    }
    
    if (playerLure != nil) {
        [playerLure addPlayersObject:player];   
    }
    
    [self.game addPlayersObject:player];
    
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

#pragma mark - LurePickerViewControllerDelegate
- (void)lurePicker:(LurePickerViewController *)picker didPickLure:(Lure *)lure
{
    playerLure = lure;
    self.lureLabel.text = playerLure.name;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
