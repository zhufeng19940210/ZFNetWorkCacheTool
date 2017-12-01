//
//  ZFNetWorkCacheTool.h
//  Cache
//
//  Created by bailing on 2017/11/30.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(NSString *error);
typedef void (^LoadProgress)(float progress);
@interface ZFNetWorkCacheTool : NSObject
/*
  单例的模式
 */
+(instancetype)ShareWorkTool;
/*
 GET:不带缓存的请求
 Url:请求的url
 parameter:请求的参数
 success:请求成功的回调
 failure:请求失败的回调
 */
-(void)GETWithUrl:(NSString *)url
        parameter:(id)parameter
          success:(SuccessBlock)success
          failure:(FailureBlock)failure;
/*
 GET:带缓存的请求
 url:请求的url
 paramter:请求的参数
 success:请求成功的回调
 failure:请求失败的回调
 */
-(void)GETCacheWithUrl:(NSString *)url
              paramter:(id)paramter
               success:(SuccessBlock)success
               failure:(FailureBlock)failure;
/*
 POST:不带缓存请求
 url:请求的url
 parameter:请求的参数
 success:请求成功的回调
 faliure:请求失败的回调
 */
-(void)POSTWithUrl:(NSString *)url
         parameter:(id)paramter
           success:(SuccessBlock)success
           failure:(FailureBlock)failure;
/*
 POST:带缓存的请求
 */
-(void)POSTCacehWithUrl:(NSString *)url
              parameter:(id)parameter
                success:(SuccessBlock )success
                failure:(FailureBlock)failure;
@end
