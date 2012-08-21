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
@dynamic comment;

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
   return [NSString stringWithFormat:@"%.1f %@", [self.score doubleValue], NSLocalizedString(@" points", nil)];
}

# pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
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

@end
