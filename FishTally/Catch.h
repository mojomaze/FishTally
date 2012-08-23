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

@interface Catch : NSManagedObject <MKAnnotation>

@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitudeDelta;
@property (nonatomic, retain) NSNumber * longitudeDelta;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * measurement;
@property (nonatomic, retain) Lure *lure;
@property (nonatomic, retain) Fish *fish;
@property (nonatomic, retain) Player *player;

- (BOOL)hasPhoto;
- (NSString *)photoPath;
- (UIImage *)photoImage;
- (void)removePhotoFile;
- (NSString *)scoreString;
- (NSNumber *)measurementWithUnits:(NSString *)units;
- (void)setMeasurement:(NSNumber *)measurement withUnits:(NSString *)units;
- (NSString *)dateString;

@end
