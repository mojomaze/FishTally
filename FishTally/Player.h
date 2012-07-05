//
//  Player.h
//  FishTally
//
//  Created by Mark Winkler on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Lure;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) NSNumber * catchCount;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) Lure *lure;

- (BOOL)hasPhoto;
- (NSString *)photoPath;
- (UIImage *)photoImage;
- (void)removePhotoFile;

@end
