//
//  Game.h
//  FishTally
//
//  Created by Mark Winkler on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Player;

@interface Game : NSManagedObject <MKAnnotation>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitudeDelta;
@property (nonatomic, retain) NSNumber * longitudeDelta;
@property (nonatomic, retain) CLPlacemark * placemark;
@property (nonatomic, retain) NSSet * players;

- (NSString *)dateString;

@end

@interface Game (CoreDataGeneratedAccessors)

- (void)addPlayersObject:(Player *)value;
- (void)removePlayersObject:(Player *)value;
- (void)addPlayers:(NSSet *)values;
- (void)removePlayers:(NSSet *)values;
@end
