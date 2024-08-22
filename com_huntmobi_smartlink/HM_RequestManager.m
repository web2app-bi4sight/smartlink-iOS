//
//  HM_RequestManager.m
//  web2app
//
//  Created by HM on 2024/07/31.
//

#import "HM_RequestManager.h"
#import <Foundation/Foundation.h>

@implementation HttpRequest

- (instancetype)initWithURLString:(NSString *)urlString
                      requestBody:(NSString *)requestBody
                         deviceID:(NSString *)deviceID
                    isHasCallback:(BOOL)isHasCallback
                         callback:(void (^)(NSDictionary *response, NSError *error))callback {
    self = [super init];
    if (self) {
        _urlString = urlString;
        _requestBody = requestBody;
        _deviceID = deviceID;
        _callback = callback;
        _isHasCallback = isHasCallback;
    }
    return self;
}

- (void)send {
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.deviceID forHTTPHeaderField:@"__hm_uuid__"];
    request.HTTPBody = [self.requestBody dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (self.callback) {
                self.callback(nil, error);
            }
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (self.callback) {
                    self.callback(responseDict, nil);
                }
            } else {
                if (self.callback) {
                    self.callback(nil, [NSError errorWithDomain:@"HTTPErrorDomain" code:httpResponse.statusCode userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"请求失败，响应码：%ld", (long)httpResponse.statusCode]}]);
                }
            }
        }
    }];
    [dataTask resume];
}

@end



@implementation HM_RequestManager

+ (instancetype)sharedInstance {
    static HM_RequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HM_RequestManager alloc] init];
        instance.requestQueue = [NSMutableArray array];
        instance.isSending = NO;
        instance.userDefaults = [NSUserDefaults standardUserDefaults];
        [instance loadRequestQueue];
    });
    return instance;
}

- (void)loadRequestQueue {
    NSArray *savedRequests = [self.userDefaults objectForKey:@"request_queue"];
    for (NSDictionary *requestDict in savedRequests) {
        HttpRequest *httpRequest = [[HttpRequest alloc] initWithURLString:requestDict[@"url"]
                                                               requestBody:requestDict[@"requestBody"]
                                                                  deviceID:requestDict[@"deviceID"]
                                                             isHasCallback:[requestDict[@"isHasCallback"] boolValue]
                                                                  callback:nil];
        [self.requestQueue addObject:httpRequest];
    }
}

- (void)saveRequestQueue {
    NSMutableArray *requestArray = [NSMutableArray array];
    for (HttpRequest *request in self.requestQueue) {
        NSDictionary *requestDict = @{
            @"url": request.urlString,
            @"requestBody": request.requestBody,
            @"deviceID": request.deviceID,
            @"isHasCallback": @(request.isHasCallback)
        };
        [requestArray addObject:requestDict];
    }
    [self.userDefaults setObject:requestArray forKey:@"request_queue"];
    [self.userDefaults synchronize];
}

- (void)sendHttpPostRequestWithURLString:(NSString *)urlString
                             requestBody:(NSString *)requestBody
                                deviceID:(NSString *)deviceID
                           isHasCallback:(BOOL)isHasCallback
                                callback:(void (^)(NSDictionary *response, NSError *error))callback {
    HttpRequest *request = [[HttpRequest alloc] initWithURLString:urlString
                                                      requestBody:requestBody
                                                         deviceID:deviceID
                                                    isHasCallback:isHasCallback
                                                         callback:callback];
    @synchronized (self.requestQueue) {
        [self.requestQueue addObject:request];
        [self saveRequestQueue];
        if (!self.isSending) {
            [self sendNextRequest];
        }
    }
}

- (void)sendNextRequest {
    @synchronized (self.requestQueue) {
        if (self.requestQueue.count > 0) {
            self.isSending = YES;
            HttpRequest *request = [self.requestQueue firstObject];
            [request send];
        } else {
            self.isSending = NO;
        }
    }
}

@end
