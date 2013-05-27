//
//  Lure.h
//  FishTally
//
//  Created by Mark Winkler on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Player, LureType;

@interface Lure : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * multiplier;
@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) NSSet *players;
@property (nonatomic, retain) NSSet *catches;
@property (nonatomic, retain) LureType *lureType;

- (BOOL)hasPhoto;
- (NSString *)photoPath;
- (UIImage *)photoImage;
- (void)removePhotoFile;
- (NSString *)lureCategory;

@end

@interface Lure (CoreDataGeneratedAccessors)

- (void)addPlayersObject:(Player *)value;
- (void)removePlayersObject:(Player *)value;
- (void)addPlayers:(NSSet *)values;
- (void)removePlayers:(NSSet *)values;
- (void)addCatchesObject:(NSManagedObject *)value;
- (void)removeCatchesObject:(NSManagedObject *)value;
- (void)addCatches:(NSSet *)values;
- (void)removeCatches:(NSSet *)values;
@end
