//
//  Fish.h
//  FishTally
//
//  Created by Mark Winkler on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Catch, FishFamily;

@interface Fish : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) NSSet *catches;
@property (nonatomic, retain) FishFamily *fishFamily;

- (BOOL)hasPhoto;
- (NSString *)photoPath;
- (UIImage *)photoImage;
- (void)removePhotoFile;
- (NSString *)familyName;

@end

@interface Fish (CoreDataGeneratedAccessors)

- (void)addCatchesObject:(Catch *)value;
- (void)removeCatchesObject:(Catch *)value;
- (void)addCatches:(NSSet *)values;
- (void)removeCatches:(NSSet *)values;
@end
