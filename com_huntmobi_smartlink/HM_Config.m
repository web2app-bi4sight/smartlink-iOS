//
//  HM_Config.m
//  HM
//
//  Created by CCC on 2022/12/2.
//

#import "HM_Config.h"
#import "HM_NetWork.h"

#define kWebUserAgentKey @"HM_WebView_UA"

@interface HM_Config ()

@property (nonatomic, strong) NSTimer *permissionCheckTimer;
@property (nonatomic, assign) BOOL allPermissionsHandled;

@end

@implementation HM_Config

static PermissionsBlock permissionsBlock;

+ (instancetype)sharedManager {
    static HM_Config *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [HM_Config new];
    });
    return config;
}


- (NSString *)getWebUA {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *ua = [userDefaults stringForKey:kWebUserAgentKey];
    if (ua == nil) {
        ua = @"";
    }
    return ua;
}

- (void)setLogEnabled:(BOOL)isEnable {
    [[HM_NetWork shareInstance] setLogEnabled:isEnable];
}

-(NSString *)getGUID{
    NSUUID *uuid = [NSUUID UUID];
    NSString *uuidString = [uuid UUIDString];
    return uuidString;
}

- (BOOL) isNewUser {
    NSDate *installDate = [self getInstallDate];
    if (installDate) {
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:installDate toDate:now options:0];
        NSInteger day = [components day];
        if (day <= 1) {
            return true;
        } else {
            return false;
        }
    } else {
        return true;
    }
}

- (NSDate *)getInstallDate {
    NSDate *installDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"HM_INSTALLDATE"];
    if (installDate) {
        return installDate;
    } else {
        // 获取应用安装日期
        installDate = [self getInstallationDateFromAttributes];
        if (installDate) {
            // 保存安装日期
            [[NSUserDefaults standardUserDefaults] setObject:installDate forKey:@"HM_INSTALLDATE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return installDate;
        }
    }
    return nil;
}

- (NSDate *)getInstallationDateFromAttributes {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray<NSURL *> *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    if (urls.count > 0) {
        NSURL *documentsDirectory = urls.lastObject;
        NSError *error;
        NSDictionary<NSFileAttributeKey, id> *attributes = [fileManager attributesOfItemAtPath:documentsDirectory.path error:&error];
        if (attributes) {
            NSDate *installDate = attributes[NSFileCreationDate];
            if (installDate) {
                return installDate;
            }
        } else {
            NSLog(@"Error retrieving installation date: %@", error);
        }
    }
    return nil;
}

- (CGFloat)returnSDKVersion {
    return 0.1;
}

- (NSString *)currentUTCTimestamp {
    NSDate *currentDate = [NSDate date];
    NSTimeInterval utcTimestamp = [currentDate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%d", (int)utcTimestamp];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
     return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
//        NSString *log = [NSString stringWithFormat:@"%d, %s | json解析失败：%@", __LINE__, __func__, err];
        return nil;
    }
    return dic;
}

@end
