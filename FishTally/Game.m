//
//  Game.m
//  FishTally
//
//  Created by Mark Winkler on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "Player.h"


@implementation Game

@dynamic name;
@dynamic date;
@dynamic players;
@dynamic latitude;
@dynamic longitude;
@dynamic longitudeDelta;
@dynamic latitudeDelta;
@dynamic placemark;

- (NSString *)dateString {
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd 'at' HH:mm" options:0
                                                              locale:[NSLocale currentLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    return [dateFormatter stringFromDate:self.date];
}

# pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return [self dateString];
}

@end
