//
//  SettingsViewController.m
//  FishTally
//
//  Created by Mark Winkler on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "LuresViewController.h"
#import "FishViewController.h"
#import "LureCategoriesViewController.h"
#import "UnitsPickerViewController.h"
#import "CatchSizesViewController.h"

@interface SettingsViewController ()

@property (nonatomic, strong) IBOutlet UILabel *fishLabel;
@property (nonatomic, strong) IBOutlet UILabel *fishFamiliesLabel;
@property (nonatomic, strong) IBOutlet UILabel *luresLabel;
@property (nonatomic, strong) IBOutlet UILabel *lureCategoriesLabel;
@property (nonatomic, strong) IBOutlet UILabel *catchSizesLabel;
@property (nonatomic, strong) IBOutlet UILabel *measurementUnitLabel;

- (void)updateAllCounts;
- (NSUInteger)getCountForEntity:(NSString *)entityName;
- (void)updateCountLabelForEntity:(NSString *)entityName;
- (void)updateMeasurementLabel;

@end

@implementation SettingsViewController {
    NSFetchRequest *fetchRequest;
    int fishCount;
    int familyCount;
    int lureCount;
    int categoryCount;
    int sizeCount;
    NSString *measurementUnits;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fishLabel = _fishLabel;
@synthesize fishFamiliesLabel = _fishFamiliesLabel;
@synthesize luresLabel = _luresLabel;
@synthesize lureCategoriesLabel = _lureCategoriesLabel;
@synthesize catchSizesLabel = _catchSizesLabel;
@synthesize measurementUnitLabel = _measurementUnitLabel;

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
    [self updateAllCounts];
    measurementUnits = [[NSUserDefaults standardUserDefaults] stringForKey:@"MeasurementUnits"];
    [self updateMeasurementLabel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.fishFamiliesLabel = nil;
    self.luresLabel = nil;
    self.lureCategoriesLabel = nil;
    self.catchSizesLabel = nil;
    self.measurementUnitLabel = nil;
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

- (void)updateAllCounts
{
    if (fetchRequest == nil) {
        fetchRequest = [[NSFetchRequest alloc] init];
    }
    NSUInteger count = [self getCountForEntity:@"Fish"];
    if (count != NSNotFound) {
        fishCount = count;
        [self updateCountLabelForEntity:@"Fish"];
    }
    count = [self getCountForEntity:@"FishFamily"];
    if (count != NSNotFound) {
        familyCount = count;
        [self updateCountLabelForEntity:@"FishFamily"];
    }
    count = [self getCountForEntity:@"Lure"];
    if (count != NSNotFound) {
        lureCount = count;
        [self updateCountLabelForEntity:@"Lure"];
    }
    count = [self getCountForEntity:@"LureType"];
    if (count != NSNotFound) {
        categoryCount = count;
        [self updateCountLabelForEntity:@"LureType"];
    }
    count = [self getCountForEntity:@"CatchSize"];
    if (count != NSNotFound) {
        sizeCount = count;
        [self updateCountLabelForEntity:@"CatchSize"];
    }
}

- (NSUInteger)getCountForEntity:(NSString *)entityName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;    
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    return count;
}

- (void)updateCountLabelForEntity:(NSString *)entityName
{    
    if ([entityName isEqualToString:@"Fish"]) {
        self.fishLabel.text = [NSString stringWithFormat:@"%d", fishCount];
    }
    if ([entityName isEqualToString:@"FishFamily"]) {
        self.fishFamiliesLabel.text = [NSString stringWithFormat:@"%d", familyCount];
    }
    if ([entityName isEqualToString:@"Lure"]) {
        self.luresLabel.text = [NSString stringWithFormat:@"%d", lureCount];
    }
    if ([entityName isEqualToString:@"LureType"]) {
        self.lureCategoriesLabel.text = [NSString stringWithFormat:@"%d", categoryCount];
    }
    
    if ([entityName isEqualToString:@"CatchSize"]) {
        self.catchSizesLabel.text = [NSString stringWithFormat:@"%d", sizeCount];
    }
}

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FishSettings"]) {
        FishViewController *controller = segue.destinationViewController;
        controller.managedObjectContext = self.managedObjectContext;
        controller.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"LureSettings"]) {
        LuresViewController *controller = segue.destinationViewController;
        controller.managedObjectContext = self.managedObjectContext;
        controller.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"LureCategories"]) {
        LureCategoriesViewController *controller = segue.destinationViewController;
        controller.managedObjectContext = self.managedObjectContext;
        controller.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"FishFamilies"]) {
        LureCategoriesViewController *controller = segue.destinationViewController;
        controller.managedObjectContext = self.managedObjectContext;
        controller.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"PickUnits"]) {
        UnitsPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.selectedUnits = measurementUnits;
    }
    
    if ([segue.identifier isEqualToString:@"CatchSizes"]) {
        CatchSizesViewController *controller = segue.destinationViewController;
        controller.managedObjectContext = self.managedObjectContext;
        controller.delegate = self;
    }
}

#pragma mark - SettingsListViewDelegate

- (void)listDidChangeCountForEntity:(NSString *)entityName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;    
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (count != NSNotFound) {
        if ([entityName isEqualToString:@"Fish"]) {
            fishCount = count;
        }
        if ([entityName isEqualToString:@"FishFamily"]) {
            familyCount = count;
        }
        if ([entityName isEqualToString:@"Lure"]) {
            lureCount = count;
        }
        if ([entityName isEqualToString:@"LureType"]) {
            categoryCount = count;
        }
        
        if ([entityName isEqualToString:@"CatchSize"]) {
            sizeCount = count;
        }
        
        [self updateCountLabelForEntity:entityName];
    }
    
}

- (void)unitsPicker:(UnitsPickerViewController *)picker didPickUnits:(NSString *)units {
    if (units != measurementUnits) {
        measurementUnits = units;
        [[NSUserDefaults standardUserDefaults] setObject:units forKey:@"MeasurementUnits"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self updateMeasurementLabel];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)updateMeasurementLabel {
    if ([measurementUnits isEqualToString:@"Centimeters"]) {
        self.measurementUnitLabel.text = @"cm";
    } else {
        self.measurementUnitLabel.text = @"in";
    }
}

@end
