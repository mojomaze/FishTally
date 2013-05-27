//
//  AssetLibrary.m
//  GlossRE
//
//  Created by mwinkler on 12/15/12.
//  Copyright (c) 2012 mwinkler. All rights reserved.
//

#import "AssetsLibraryFactory.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

static AssetsLibraryFactory* s_assetLibrary;

@implementation AssetsLibraryFactory

+(id)sharedInstance
{
    if (s_assetLibrary == nil) {
        s_assetLibrary = [[AssetsLibraryFactory alloc] init];
    }
    
    return s_assetLibrary;
}

+(void)createAssetFromImage:(UIImage *)image
{
    if (s_assetLibrary == nil) {
        s_assetLibrary = [[AssetsLibraryFactory alloc] init];
    }
    [s_assetLibrary __createAssetFromImage:image];
}

+(void)addAssetURL:(NSURL *)assetURL
{
    if (s_assetLibrary == nil) {
        s_assetLibrary = [[AssetsLibraryFactory alloc] init];
    }
    [s_assetLibrary __addAssetURL:assetURL];
}

-(id)init
{
    if(self = [super init])
    {
        mAssetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    return self;
}

-(ALAssetsLibrary *)library
{
    return mAssetsLibrary;
}

# pragma mark - Private

-(void)__createAssetFromImage:(UIImage*)image
{
    // save image to camera roll and set photo properties
    [mAssetsLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation
                      completionBlock:^(NSURL* assetURL, NSError* error) {
                          if (error) {
                              NSLog(@"Error saving photo to assets: %@", [error description]);
                              return;
                          }
                          [self __addAssetURL:assetURL];
                      }];
}


-(void)__addAssetURL:(NSURL *)assetURL
{
    [mAssetsLibrary addAssetURL:assetURL toAlbum:@"FishTally" withCompletionBlock:^(NSError *error) {
        if (error) {
            NSLog(@"Save Asset to Group Error: %@", [error description]);
        }
    }];
}

@end
