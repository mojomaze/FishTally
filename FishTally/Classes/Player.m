//
//  Player.m
//  FishTally
//
//  Created by Mark Winkler on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Catch.h"
#import "Game.h"
#import "Lure.h"


@implementation Player

@dynamic name;
@dynamic photoId;
@dynamic catchCount;
@dynamic score;
@dynamic game;
@dynamic lure;
@dynamic catches;

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
    NSString *filename = [NSString stringWithFormat:@"Player-Photo-%d.png", [self.photoId intValue]];
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

- (void) calculatePlayerScore {
    double score = 0;
    for (Catch *catch in self.catches) {
        score += [catch.score doubleValue];
    }
    self.score = [NSNumber numberWithDouble:score];
}

@end
