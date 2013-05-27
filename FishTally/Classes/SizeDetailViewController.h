//
//  SizeDetailViewController.h
//  FishTally
//
//  Created by Mark Winkler on 8/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SizeDetailViewController;

@protocol SizeDetailDelegate <NSObject>
- (void) sizeController:(SizeDetailViewController *)controller didSetSize:(NSNumber *)newSize;
@end

@interface SizeDetailViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, weak) id <SizeDetailDelegate> delegate;
@property (nonatomic, strong) NSString *units;

@end
