//
//  Catch.h
//  FishTally
//
//  Created by Mark Winkler on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lure, Player;

@interface Catch : NSManagedObject

@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) Lure *lure;
@property (nonatomic, retain) NSManagedObject *fish;
@property (nonatomic, retain) Player *player;

@end
