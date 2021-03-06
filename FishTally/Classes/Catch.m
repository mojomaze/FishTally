//
//  Catch.m
//  FishTally
//
//  Created by Mark Winkler on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Catch.h"
#import "Lure.h"
#import "Player.h"
#import "Fish.h"
#import "Game.h"

@implementation Catch

@dynamic score;
@dynamic size;
@dynamic photoId;
@dynamic lure;
@dynamic fish;
@dynamic player;
@dynamic date;
@dynamic latitude;
@dynamic longitude;
@dynamic latitudeDelta;
@dynamic longitudeDelta;
@dynamic measurement;
@dynamic comment;
@dynamic sizeName;
@dynamic sizeMultiplier;
@dynamic lureMultiplier;
@dynamic fishPoints;

- (BOOL)hasPhoto
{
    return (self.photoId != nil) && ([self.photoId intValue] != -1);
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString *)photoPath
{
    NSString *filename = [NSString stringWithFormat:@"Catch-Photo-%d.png", [self.photoId intValue]];
    return [[self documentsDirectory] stringByAppendingPathComponent:filename];
}

- (UIImage *)photoImage
{
    NSAssert(self.photoId != nil, @"No photo ID set");
    NSAssert([self.photoId intValue] != -1, @"Photo ID is -1");
    
    return [UIImage imageWithContentsOfFile:[self photoPath]];
}

- (void)removePhotoFile
{
    NSString *path = [self photoPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error;
        if (![fileManager removeItemAtPath:path error:&error]) {
            NSLog(@"Error removing file: %@", error);
        }
    }
}

- (NSString *)scoreString {
    if ([self.score doubleValue] == 1.0f) {
        return [NSString stringWithFormat:@"%.1f %@", [self.score doubleValue], NSLocalizedString(@"point", nil)];
    }
   return [NSString stringWithFormat:@"%.1f %@", [self.score doubleValue], NSLocalizedString(@"points", nil)];
}

- (NSString *)dateString {
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0
                                                              locale:[NSLocale currentLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    return [dateFormatter stringFromDate:self.date];
}

# pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    double latitude = [self.latitude doubleValue];
    double longitute = [self.longitude doubleValue];
    if (latitude == 0 && longitute == 0) {
        //try game coordinates
       return CLLocationCoordinate2DMake([self.player.game.latitude doubleValue], [self.player.game.longitude doubleValue]); 
    }
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSString *)title
{
    return self.fish.name;
}

- (NSString *)subtitle
{
    return [self scoreString];
}

// Storing measurement in centimeters
// used for converting stored value to inches
- (NSNumber *)measurementWithUnits:(NSString *)units {
    if ([[units lowercaseString] isEqualToString:@"in"] || [[units lowercaseString] isEqualToString:@"inches"]) {
        double length = [self.measurement doubleValue] * 0.393701f;
        return [NSNumber numberWithDouble:length];
    }
    return self.measurement;
}

// used for storing value as centimeters
- (void)setMeasurement:(NSNumber *)measurement withUnits:(NSString *)units {
    if ([[units lowercaseString] isEqualToString:@"in"] || [[units lowercaseString] isEqualToString:@"inches"]) {
        double length = [measurement doubleValue] / 0.393701f;
        self.measurement = [NSNumber numberWithDouble:length];
        
    } else {
        self.measurement = measurement;
    }
}

@end
