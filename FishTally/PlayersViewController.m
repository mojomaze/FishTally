//
//  PlayersViewController.m
//  FishTally
//
//  Created by Mark Winkler on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayersViewController.h"
#import "Player.h"
#import "PlayerCell.h"
#import "Game.h"
#import "PlayerDetailViewController.h"
#import "CatchesViewController.h"
#import "UIImage+Resize.h"
#import "LocationsViewController.h"

@implementation PlayersViewController {
    NSFetchedResultsController *fetchedResultsController;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize game = _game;

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

#pragma mark - View lifecycle

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController == nil) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        if (self.game != nil) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"game == %@", self.game];
            [fetchRequest setPredicate:predicate];
        }
        
        NSSortDescriptor *primarySort = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
        NSSortDescriptor *secondarySort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:primarySort, secondarySort, nil]];
        
        [fetchRequest setFetchBatchSize:20];
        
        fetchedResultsController = [[NSFetchedResultsController alloc]
                                    initWithFetchRequest:fetchRequest
                                    managedObjectContext:self.managedObjectContext
                                    sectionNameKeyPath:nil
                                    cacheName:nil];
        
        fetchedResultsController.delegate = self;
    }
    return fetchedResultsController;
}

- (void)performFetch
{
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        FATAL_CORE_DATA_ERROR(error);
        return;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performFetch];
    UIToolbar *toolbar = [self.navigationController toolbar];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.translucent = YES;
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Map.png"]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(showLocations:)];
    [self setToolbarItems:[NSArray arrayWithObjects:mapButton, nil]];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    fetchedResultsController.delegate = nil;
    fetchedResultsController = nil;
}

- (void)dealloc
{
    fetchedResultsController.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
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

- (void)showLocations:(id)sender {
    [self performSegueWithIdentifier:@"ShowLocations"
                              sender:sender]; 
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    PlayerCell *playerCell = (PlayerCell *)cell;
    Player *player = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    playerCell.nameLabel.text = player.name;
    
    UIImage *image = nil;
    if ([player hasPhoto]) {
        image = [player photoImage];
        if (image != nil) {
            image = [image resizedImageWithBounds:CGSizeMake(66, 66) withAspectType:ImageAspectTypeFill];
        }
    }
    playerCell.photoImageView.image = image;
    playerCell.scoreLabel.text = [NSString stringWithFormat:@"%.1f %@", [player.score doubleValue], NSLocalizedString(@" points", nil)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Player"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"EditPlayer"
                              sender:cell]; 
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Player *player = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:player];
        
        [self.game removePlayersObject:player];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            FATAL_CORE_DATA_ERROR(error);
            return;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // add player called from nav button
    if ([segue.identifier isEqualToString:@"AddPlayer"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        PlayerDetailViewController *controller = (PlayerDetailViewController *)navigationController.topViewController;
        controller.managedObjectContext = self.managedObjectContext;
        controller.game = self.game;
    }
    
    // edit player called from accessory button
    if ([segue.identifier isEqualToString:@"EditPlayer"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        PlayerDetailViewController *controller = (PlayerDetailViewController *)navigationController.topViewController;
        controller.managedObjectContext = self.managedObjectContext;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Player *player = [self.fetchedResultsController objectAtIndexPath:indexPath];
        controller.playerToEdit = player;
        controller.game = self.game;
    }
    
    if ([segue.identifier isEqualToString:@"PlayerCatches"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Player *player = [self.fetchedResultsController objectAtIndexPath:indexPath];
        CatchesViewController *viewController = segue.destinationViewController;
        viewController.managedObjectContext = self.managedObjectContext;
        viewController.player = player;
        [viewController setTitle:player.name];
    }
    
    if ([segue.identifier isEqualToString:@"ShowLocations"]) {
        LocationsViewController *controller = segue.destinationViewController;
        [controller setTitle:@"Catch Locations"];
        NSArray *catches = [self.game allCatches];
        controller.annotations = catches;
        controller.managedObjectContext = self.managedObjectContext;
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"*** controllerWillChangeContent");
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"*** controllerDidChangeObject - NSFetchedResultsChangeInsert");
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"*** controllerDidChangeObject - NSFetchedResultsChangeDelete");
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            NSLog(@"*** controllerDidChangeObject - NSFetchedResultsChangeUpdate");
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            NSLog(@"*** controllerDidChangeObject - NSFetchedResultsChangeMove");
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"*** controllerDidChangeSection - NSFetchedResultsChangeInsert");
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"*** controllerDidChangeSection - NSFetchedResultsChangeDelete");
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"*** controllerDidChangeContent");
    [self.tableView endUpdates];
}

@end
