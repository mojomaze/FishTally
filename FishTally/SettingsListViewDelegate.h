//
//  SettingsListViewDelegate.h
//  FishTally
//
//  Created by Mark Winkler on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SettingsListViewDelegate <NSObject>

- (void)listDidChangeCountForEntity:(NSString *)entityName;

@end
