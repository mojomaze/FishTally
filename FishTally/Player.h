//
//  Player.h
//  FishTally
//
//  Created by Mark Winkler on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) NSNumber * photoId;

- (BOOL)hasPhoto;
- (NSString *)photoPath;
- (UIImage *)photoImage;
- (void)removePhotoFile;


@end
