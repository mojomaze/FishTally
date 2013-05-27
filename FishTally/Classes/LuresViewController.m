//
//  LuresViewController.m
//  FishTally
//
//  Created by Mark Winkler on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LuresViewController.h"
#import "Lure.h"
#import "LureDetailViewController.h"
#import "UIImage+Resize.h"


@implementation LuresViewController {
    NSFetchedResultsController *fetchedResultsController;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize delegate = _delegate;

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
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Lure" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"lureType.name" ascending:YES];
        NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]];
        
        [fetchRequest setFetchBatchSize:20];
        
        fetchedResultsController = [[NSFetchedResultsController alloc]
                                    initWithFetchRequest:fetchRequest
                                    managedObjectContext:self.managedObjectContext
                                    sectionNameKeyPath:@"lureType.name"
                                    cacheName:@"Lures"];
        
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Lure *lure = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = lure.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f %@", [lure.multiplier doubleValue], NSLocalizedString(@"x points", nil)];
    
    UIImage *image = nil;
    if ([lure hasPhoto]) {
        image = [lure photoImage];
        if (image != nil) {
            image = [image resizedImageWithBounds:CGSizeMake(44, 44) withAspectType:ImageAspectTypeFit];
        }
    }
    cell.imageView.image = image;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Lure"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"EditLure"
                              sender:cell]; 
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Lure *lure = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:lure];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            FATAL_CORE_DATA_ERROR(error);
            return;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // add lure called from nav button
    if ([segue.identifier isEqualToString:@"AddLure"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        LureDetailViewController *controller = (LureDetailViewController *)navigationController.topViewController;
        controller.managedObjectContext = self.managedObjectContext;
    }
    
    // edit lure called from accessory button
    if ([segue.identifier isEqualToString:@"EditLure"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        LureDetailViewController *controller = (LureDetailViewController *)navigationController.topViewController;
        controller.managedObjectContext = self.managedObjectContext;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Lure *lure = [self.fetchedResultsController objectAtIndexPath:indexPath];
        controller.lureToEdit = lure;
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
            [self.delegate listDidChangeCountForEntity:@"Lure"];
            break;
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"*** controllerDidChangeObject - NSFetchedResultsChangeDelete");
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.delegate listDidChangeCountForEntity:@"Lure"];
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
