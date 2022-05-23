//
//  ANLaunchService.m
//  AppleNetworkDevice
//
//  Created by Sergii Kryvoblotskyi on 5/23/22.
//

#import "ANLaunchService.h"

extern NSString* _LSCreateDeviceTypeIdentifierWithModelCode(NSString *);

@implementation ANLaunchService

+ (NSString *)deviceTypeIdentifierFromModelCode:(NSString *)modelCode
{
    return _LSCreateDeviceTypeIdentifierWithModelCode(modelCode);
}

@end
