//
//  AssetLibrary.h
//  GlossRE
//
//  Created by mwinkler on 12/15/12.
//  Copyright (c) 2012 mwinkler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AssetsLibraryFactory : NSObject
{
    ALAssetsLibrary*            mAssetsLibrary;
}

+(id)sharedInstance;
+(void)createAssetFromImage:(UIImage *)image;
+(void)addAssetURL:(NSURL *)assetURL;

-(ALAssetsLibrary *)library;
@end

@interface AssetsLibraryFactory (Private)
-(void)__createAssetFromImage:(UIImage*)image;
-(void)__addAssetURL:(NSURL *)assetURL;
@end
