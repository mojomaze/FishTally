//
//  FishPickerViewController.m
//  FishTally
//
//  Created by Mark Winkler on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FishPickerViewController.h"
#import "Fish.h"
#import "UIImage+Resize.h"

@implementation FishPickerViewController {
    NSArray *fishs;
    NSIndexPath *selectedIndexPath;
    NSMutableArray *families;
}

@synthesize delegate = _delegate;
@synthesize selectedFish = _selectedFish;
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
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fish" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"family" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSError *error;
    fishs = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // setup sections using fish.family property
    families = [[NSMutableArray alloc] init];
    for (Fish *fish in fishs) {
        if(![families containsObject:fish.family]) {
            [families addObject:fish.family];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    fishs = nil;
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

- (NSArray *)fishInFamily:(NSString *)family {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"family == %@", family];
    return [fishs filteredArrayUsingPredicate:predicate];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [families count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [families objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *family = [families objectAtIndex:section];
    return [[self fishInFamily:family] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Fish";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // get section family
    NSArray *fishInSection = [self fishInFamily:[families objectAtIndex:[indexPath section]]];
    if ([fishInSection count] > 0) {
        // get the fish at the current row
        Fish *fish = [fishInSection objectAtIndex:indexPath.row];
        cell.textLabel.text = fish.name;
        UIImage *image = nil;
        if ([fish hasPhoto]) {
            image = [fish photoImage];
            if (image != nil) {
                image = [image resizedImageWithBounds:CGSizeMake(44, 44) withAspectType:ImageAspectTypeFit];
            }
        }
        cell.imageView.image = image;
        
        if ([fish isEqual:self.selectedFish]) {
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
    if (indexPath != selectedIndexPath) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        selectedIndexPath = indexPath;
    }
    
    NSArray *fishInSection = [self fishInFamily:[families objectAtIndex:[indexPath section]]];
    
    Fish *fish = [fishInSection objectAtIndex:indexPath.row];
    [self.delegate fishPicker:self didPickFish:fish];
}

@end
