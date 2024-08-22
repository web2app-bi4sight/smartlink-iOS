//
//  HM_RequestManager.h
//  web2app
//
//  Created by HM on 2024/07/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequest : NSObject

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *requestBody;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, copy) void (^callback)(NSDictionary *response, NSError *error);
@property (nonatomic, assign) BOOL isHasCallback;

- (instancetype)initWithURLString:(NSString *)urlString
                      requestBody:(NSString *)requestBody
                         deviceID:(NSString *)deviceID
                    isHasCallback:(BOOL)isHasCallback
                         callback:(void (^)(NSDictionary *response, NSError *error))callback;

- (void)send;

@end

@interface HM_RequestManager : NSObject

@property (nonatomic, strong) NSMutableArray<HttpRequest *> *requestQueue;
@property (nonatomic, assign) BOOL isSending;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

+ (instancetype)sharedInstance;
- (void)sendHttpPostRequestWithURLString:(NSString *)urlString
                             requestBody:(NSString *)requestBody
                                deviceID:(NSString *)deviceID
                           isHasCallback:(BOOL)isHasCallback
                                callback:(void (^)(NSDictionary *response, NSError *error))callback;

@end

NS_ASSUME_NONNULL_END
