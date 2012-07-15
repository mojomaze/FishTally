//
//  LurePickerViewController.m
//  FishTally
//
//  Created by Mark Winkler on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LurePickerViewController.h"
#import "Lure.h"
#import "UIImage+Resize.h"


@implementation LurePickerViewController {
    NSArray *lures;
    NSIndexPath *selectedIndexPath;
    NSMutableArray *categories;
}

@synthesize delegate = _delegate;
@synthesize selectedLure = _selectedLure;
@synthesize managedObjectContext = _managedObjectContext;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Lure" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSError *error;
    lures = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Setup sections using lure.category
    categories = [[NSMutableArray alloc] init]; 
    for (Lure *lure in lures) {
        if (![categories containsObject:lure.category]) {
            [categories addObject:lure.category];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    lures = nil;
    selectedIndexPath = nil;
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSArray *)luresInCategories:(NSString *)category {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", category];
    return [lures filteredArrayUsingPredicate:predicate];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [categories count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [categories objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *category = [categories objectAtIndex:section];
    return [[self luresInCategories:category] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Lure";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // get section category
    NSArray *luresInSection = [self luresInCategories:[categories objectAtIndex:[indexPath section]]];
    if ([luresInSection count] > 0) {
        // get the lure at the current row
        Lure *lure = [luresInSection objectAtIndex:indexPath.row];
        cell.textLabel.text = lure.name;
        UIImage *image = nil;
        if ([lure hasPhoto]) {
            image = [lure photoImage];
            if (image != nil) {
                image = [image resizedImageWithBounds:CGSizeMake(44, 44) withAspectType:ImageAspectTypeFill];
            }
        }
        cell.imageView.image = image;
        
        if ([lure isEqual:self.selectedLure]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            selectedIndexPath = indexPath;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != selectedIndexPath.row) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        selectedIndexPath = indexPath;
    }
    
    NSArray *luresInSection = [self luresInCategories:[categories objectAtIndex:[indexPath section]]];
    
    Lure *lure = [luresInSection objectAtIndex:indexPath.row];
    [self.delegate lurePicker:self didPickLure:lure];
}

@end
