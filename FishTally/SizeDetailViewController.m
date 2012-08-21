//
//  SizeDetailViewController.m
//  FishTally
//
//  Created by Mark Winkler on 8/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SizeDetailViewController.h"

@interface SizeDetailViewController ()

@end

@implementation SizeDetailViewController {
    NSMutableArray *values;
}

@synthesize pickerView = _pickerView;
@synthesize size = _size;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNumber *initValue = [NSNumber numberWithInt:0];
	values = [[NSMutableArray alloc] initWithObjects:initValue, initValue, initValue, initValue, nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

# pragma mark - UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 6;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component < 3 || component == 4) {
        return 10;
    }
    return 1;
}

- (void)calculateSizeFromValues {
    double newSize;
    NSArray *multipliers = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:100], [NSNumber numberWithInt:10], [NSNumber numberWithInt:1],[NSNumber numberWithInt:0], nil];
    for (int i=0; i < [values count]; i++) {
        int multiplier = [[multipliers objectAtIndex:i] intValue];
        int value = [[values objectAtIndex:i] intValue];
        if (multiplier == 0) {
            newSize += value / 10.0f;
        } else {
            newSize += multiplier * value;
        } 
    }
    self.size = [NSNumber numberWithDouble:newSize];
}

# pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 3) {
        return @".";
    }
    if (component == 5) {
        return @"in";
    }

    return [NSString stringWithFormat:@"%d",row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSNumber *value = [NSNumber numberWithInt:row];
    if (component < 3) {
        [values replaceObjectAtIndex:component withObject:value];
    } else {
        [values replaceObjectAtIndex:3 withObject:value];
    }
    [self calculateSizeFromValues];
    NSLog(@"size changed to %.1f", [self.size doubleValue]);
    [self.delegate sizeController:self didSetSize:self.size];
}


@end
