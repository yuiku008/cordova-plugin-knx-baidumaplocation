/*
 *
 * 　　┏┓　　　┏┓+ +
 * 　┏┛┻━━━┛┻┓ + +
 * 　┃　　　　　　　┃
 * 　┃　　　━　　　┃ ++ + + +
 *  ████━████ ┃+
 * 　┃　　　　　　　┃ +
 * 　┃　　　┻　　　┃
 * 　┃　　　　　　　┃ + +
 * 　┗━┓　　　┏━┛
 * 　　　┃　　　┃
 * 　　　┃　　　┃ + + + +
 * 　　　┃　　　┃
 * 　　　┃　　　┃ +  神兽保佑
 * 　　　┃　　　┃    代码无bug
 * 　　　┃　　　┃　　+
 * 　　　┃　 　　┗━━━┓ + +
 * 　　　┃ 　　　　　　　┣┓
 * 　　　┃ 　　　　　　　┏┛
 * 　　　┗┓┓┏━┳┓┏┛ + + + +
 * 　　　　┃┫┫　┃┫┫
 * 　　　　┗┻┛　┗┻┛+ + + +
 *
 */

//
//  BaiduMapLocation.mm
//
//  Created by LiuRui on 2017/2/25.
//  modify by ShawnSha on 2021/8/16
//

#import "BaiduMapLocation.h"

@implementation BaiduMapLocation


- (void)pluginInitialize
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSString* IOS_KEY = [[plistDic objectForKey:@"BaiduMapLocation"] objectForKey:@"IOS_KEY"];
    
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:IOS_KEY authDelegate:nil];
    
    //初始化实例
    _localManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _localManager.delegate = self;
    //设置返回位置的坐标系类型
    _localManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _localManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _localManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _localManager.activityType = CLActivityTypeAutomotiveNavigation;
     //设置是否自动停止位置更新
    _localManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    _localManager.allowsBackgroundLocationUpdates = YES;
     //设置位置获取超时时间
    _localManager.locationTimeout = 8;
    //设置获取地址信息超时时间
    _localManager.reGeocodeTimeout = 8;
}
- (void)getCurrentPosition:(CDVInvokedUrlCommand*)command
{
    _execCommand = command;
//    [_localManager setLocatingWithReGeocode:YES];
//    [_localManager startUpdatingLocation];
    /// 参数
        // withReGeocode    是否带有逆地理信息(获取逆地理信息需要联网)
        // withNetWorkState    是否带有移动热点识别状态(需要联网)
        // completionBlock    单次定位完成后的Block
        // 返回
        // 是否成功添加单次定位Request
        [_localManager requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable userLocation, BMKLocationNetworkState state, NSError * _Nullable error) {
             //获取经纬度和该定位点对应的位置信息
            NSMutableDictionary* _data = [[NSMutableDictionary alloc] init];
            
            if(error){
                NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
                NSNumber* errorCode = [NSNumber numberWithInteger: error.code];
                NSString* errorDesc = error.localizedDescription;
                
                [_data setValue:errorCode forKey:@"errorCode"];
                [_data setValue:errorDesc forKey:@"errorDesc"];
            }if(userLocation){
                if(userLocation.location){
                    NSDate* time = userLocation.location.timestamp;
                    NSNumber* latitude = [NSNumber numberWithDouble:userLocation.location.coordinate.latitude];
                    NSNumber* longitude = [NSNumber numberWithDouble:userLocation.location.coordinate.longitude];
                    NSNumber* radius = [NSNumber numberWithDouble:userLocation.location.horizontalAccuracy];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    [_data setValue:[dateFormatter stringFromDate:time] forKey:@"time"];
                    [_data setValue:latitude forKey:@"latitude"];
                    [_data setValue:longitude forKey:@"longitude"];
                    [_data setValue:radius forKey:@"radius"];
                }
                if(userLocation.rgcData){
                    NSString* country = userLocation.rgcData.country;
                    NSString* countryCode = userLocation.rgcData.countryCode;
                    NSString* city = userLocation.rgcData.city;
                    NSString* cityCode = userLocation.rgcData.cityCode;
                    NSString* district = userLocation.rgcData.district;
                    NSString* street = userLocation.rgcData.street;
                    NSString* province = userLocation.rgcData.province;
                    NSString* locationDescribe = userLocation.rgcData.locationDescribe;
                    NSString* streetNumber = userLocation.rgcData.streetNumber;
                    NSString* adCode = userLocation.rgcData.adCode;
                    NSString* locTypeDescription  = @"successful";
                    [_data setValue:countryCode forKey:@"countryCode"];
                    [_data setValue:country forKey:@"country"];
                    [_data setValue:cityCode forKey:@"citycode"];
                    [_data setValue:city forKey:@"city"];
                    [_data setValue:district forKey:@"district"];
                    [_data setValue:street forKey:@"street"];
                    [_data setValue:streetNumber forKey:@"street"];
                    [_data setValue:province forKey:@"province"];
                    [_data setValue:adCode forKey:@"adCode"];
                    [_data setValue:locationDescribe forKey:@"locationDescribe"];
                    [_data setValue:locTypeDescription forKey:@"locTypeDescription"];
                }
            }
            
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:_data];
            [result setKeepCallbackAsBool:TRUE];
            [self.commandDelegate sendPluginResult:result callbackId:_execCommand.callbackId];
            
            [_localManager stopUpdatingLocation];
            _execCommand = nil;
        }];
}

@end
