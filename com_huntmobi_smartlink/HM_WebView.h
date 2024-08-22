//
//  HM_WebView.h
//  web2app
//
//  Created by HM on 2024/07/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HMWebUABlock)(NSString *uaString);

@interface HM_WebView : NSObject

+ (instancetype)shared;
- (void)HMWebUABlock:(HMWebUABlock)block;
-(void)creatWebView;
@end

NS_ASSUME_NONNULL_END
