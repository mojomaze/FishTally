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
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSError *error;
    fishs = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fishs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Fish";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Fish *fish = [fishs objectAtIndex:indexPath.row];
    cell.textLabel.text = fish.name;
    UIImage *image = nil;
    if ([fish hasPhoto]) {
        image = [fish photoImage];
        if (image != nil) {
            image = [image resizedImageWithBounds:CGSizeMake(44, 44) withAspectType:ImageAspectTypeFill];
        }
    }
    cell.imageView.image = image;
    
    if ([fish isEqual:self.selectedFish]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectedIndexPath = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    
    Fish *fish = [fishs objectAtIndex:indexPath.row];
    [self.delegate fishPicker:self didPickFish:fish];
}

@end
