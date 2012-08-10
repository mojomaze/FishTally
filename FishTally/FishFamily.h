//
//  FishFamily.h
//  FishTally
//
//  Created by Mark Winkler on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Fish;

@interface FishFamily : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *fish;
@end

@interface FishFamily (CoreDataGeneratedAccessors)

- (void)addFishObject:(Fish *)value;
- (void)removeFishObject:(Fish *)value;
- (void)addFish:(NSSet *)values;
- (void)removeFish:(NSSet *)values;

@end
