/* 
 * @Date: 2021-08-16 13:37:42
 * @LastEditTime: 2021-08-16 18:28:52
 * @LastEditors: Please set LastEditors
 * @Description: 升级百度地图2.0 SDK
 * @FilePath: /cordova-plugin-baidumaplocation/src/ios/BaiduMapLocation.h
 */
//
//  BaiduMapLocation.h
//
//  Created by LiuRui on 2017/2/25.
//

#import <Cordova/CDV.h>

#import <BMKLocationKit/BMKLocationComponent.h>

@interface BaiduMapLocation : CDVPlugin<BMKLocationManagerDelegate> {
    BMKLocationManager* _localManager;
    CDVInvokedUrlCommand* _execCommand;
}


- (void)getCurrentPosition:(CDVInvokedUrlCommand*)command;
@end
