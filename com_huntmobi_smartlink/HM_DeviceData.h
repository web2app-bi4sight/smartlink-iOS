//
//  HM_DeviceInfo.h
//  web2app
//
//  Created by HM on 2024/07/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HM_DeviceData : NSObject

+(instancetype) sharedManager;


-(void) saveDeviceInfo;


@end

NS_ASSUME_NONNULL_END
