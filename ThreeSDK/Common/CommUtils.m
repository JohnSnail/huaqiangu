//
//  CommUtils.m
//  jianzhi
//
//  Created by Jiangwei on 15/5/27.
//  Copyright (c) 2015年 li. All rights reserved.
//

#import "CommUtils.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "MainHeader.h"

#define kKeychainUDIDItemIdentifier  @"TXJZ"

@implementation CommUtils

+ (NSString *)imei
{
    if (IS_IOS_7) {
        
        NSString *uuid =  [SFHFKeychainUtils getPasswordForUsername:SKU andServiceName:kKeychainUDIDItemIdentifier error:nil];
        
        if (!uuid) {
            uuid = [NSString stringWithFormat:@"%@-%@", [[UIDevice currentDevice].identifierForVendor UUIDString], SKU];
            
            [SFHFKeychainUtils storeUsername:SKU andPassword:uuid forServiceName:kKeychainUDIDItemIdentifier updateExisting:YES error:nil];
        }
        
        
        return  uuid;
    }
    
    return [CommUtils macAddress];
}

+ (NSString *)macAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}

+ (NSString*)getMachine{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    
    free(name);
    
    if( [machine isEqualToString:@"i386"] || [machine isEqualToString:@"x86_64"] ) machine = @"ios_Simulator";
    else if( [machine isEqualToString:@"iPhone1,1"] ) machine = @"iPhone_1G";
    else if( [machine isEqualToString:@"iPhone1,2"] ) machine = @"iPhone_3G";
    else if( [machine isEqualToString:@"iPhone2,1"] ) machine = @"iPhone_3GS";
    else if( [machine isEqualToString:@"iPhone3,1"] ) machine = @"iPhone_4";
    else if( [machine isEqualToString:@"iPod1,1"] ) machine = @"iPod_Touch_1G";
    else if( [machine isEqualToString:@"iPod2,1"] ) machine = @"iPod_Touch_2G";
    else if( [machine isEqualToString:@"iPod3,1"] ) machine = @"iPod_Touch_3G";
    else if( [machine isEqualToString:@"iPod4,1"] ) machine = @"iPod_Touch_4G";
    else if( [machine isEqualToString:@"iPad1,1"] ) machine = @"iPad_1";
    else if( [machine isEqualToString:@"iPad2,1"] ) machine = @"iPad_2";
    
    return machine;
}

+(NSString *)getVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return version;
}

+(BOOL)is_onLine{
    BOOL is_on = (BOOL)[CommUtils getUserKey];
    
    return is_on;
}

+(UILabel *)navTittle:(NSString *)title
{
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 200, 44)];
    titleText.textAlignment=NSTextAlignmentCenter;
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=[UIColor whiteColor];
    titleText.text= title;
    titleText.font=[UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    [titleText sizeToFit];
    return titleText;
}

+(void)saveMobileKey:(NSString *)mobile_key
{
    [[NSUserDefaults standardUserDefaults] setObject:mobile_key forKey:@"mobile_key"];
}

+(NSString *)getMobileKey
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"mobile_key"]) {
        return @"42E6ADED-E014-393F-C03D-8405B651A4BD";
    }else{
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile_key"];
    }
}

+(void)saveAllowQQLogin:(NSString *)allow_qq_login
{
    [[NSUserDefaults standardUserDefaults] setObject:allow_qq_login forKey:@"allow_qq_login"];
}

+(NSString *)getAllowQQLogin
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"allow_qq_login"];
}

+(void)saveUserKey:(NSString *)user_key
{
    [[NSUserDefaults standardUserDefaults] setObject:user_key forKey:@"user_key"];
}

+(NSString *)getUserKey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"user_key"];
}

+(void)quitLoginAction
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_key"];
}

+(UserModel *)readUser{
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:@"user"];
//    NSLog(@"path=%@",path);
    
    //2.从文件中读取对象
    UserModel *user=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
//    TLog(@"user = %@",user.figure_url);
    
    if (!user.intro) {
        user.intro = @"";
    }
    if (!user.work_experience) {
        user.work_experience = @"";
    }
    
    return user;
}

+(void)saveUserModel:(UserModel *)user{
    
    
    if ([user.college_enroll_time isEqualToString:@"0000-00-00"]) {
        user.college_enroll_time = @"";
    }
    //2.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:@"user"];
//    NSLog(@"path=%@",path);
    
    //3.将自定义的对象保存到文件中
    [NSKeyedArchiver archiveRootObject:user toFile:path];
}

+(NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss +0000"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+(NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss  +0000"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

//获取年份
+(NSInteger)getAgeAction:(NSDate *)testDate
{
    NSDate *currentDate = testDate;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    return [components year]; // gives you year
}


@end
