//
//  Catch.h
//  FishTally
//
//  Created by Mark Winkler on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lure, Player, Fish;

@interface Catch : NSManagedObject

@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) Lure *lure;
@property (nonatomic, retain) Fish *fish;
@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) NSDate * date;

- (BOOL)hasPhoto;
- (NSString *)photoPath;
- (UIImage *)photoImage;
- (void)removePhotoFile;

@end
