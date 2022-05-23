//
//  ANLaunchService.h
//  AppleNetworkDevice
//
//  Created by Sergii Kryvoblotskyi on 5/23/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ANLaunchService : NSObject

+ (NSString *)deviceTypeIdentifierFromModelCode:(NSString *)modelCode;

@end

NS_ASSUME_NONNULL_END
