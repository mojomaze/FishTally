//
//  LureType.h
//  FishTally
//
//  Created by Mark Winkler on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lure;

@interface LureType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *lure;
@end

@interface LureType (CoreDataGeneratedAccessors)

- (void)addLureObject:(Lure *)value;
- (void)removeLureObject:(Lure *)value;
- (void)addLure:(NSSet *)values;
- (void)removeLure:(NSSet *)values;

@end
