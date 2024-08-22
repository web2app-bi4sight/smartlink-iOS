//
//  hm.h
//  web2app
//
//  Created by HM on 2024/06/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HM_SmartLink : NSObject

@property (nonatomic, assign) BOOL isNewUser;
@property (nonatomic, copy) NSString *deviceTrackID;
@property (nonatomic, copy) NSString *codeString;
@property (nonatomic, copy) NSString *fromString;
@property (nonatomic, copy) NSArray *codesArray;

+ (instancetype)sharedInstance;

-(void) attibuteBlock : (void(^)(NSDictionary * dic))block;

-(void) setSCodes:(NSString *)sCodes;

- (void)continueUserActivity:(NSUserActivity * _Nullable)userActivity;

- (void)setLogEnabled:(BOOL) isEnable;


@end

NS_ASSUME_NONNULL_END
