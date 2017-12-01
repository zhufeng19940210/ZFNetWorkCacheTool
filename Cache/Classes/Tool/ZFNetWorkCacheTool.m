//
//  ZFNetWorkCacheTool.m
//  Cache
//
//  Created by bailing on 2017/11/30.
//  Copyright © 2017年 bailing. All rights reserved.
//
#import <AFNetworking.h>
#import <YYCache.h>
#import "ZFNetWorkCacheTool.h"
static ZFNetWorkCacheTool *tool = nil;
AFHTTPSessionManager *session = nil;
// 请求方式
typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeGet,
    RequestTypePost,
    RequestTypeUpLoad,
    RequestTypeDownload
};
@implementation ZFNetWorkCacheTool
+(instancetype)ShareWorkTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[ZFNetWorkCacheTool alloc]init];
        session = [AFHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
        session.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return tool;
}
#pragma mark  网络判断
-(BOOL)requestBeforeJudgeConnect
{
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags =
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags) {
        printf("Error. Count not recover network reachability flags\n");
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL isNetworkEnable  =(isReachable && !needsConnection) ? YES : NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible =isNetworkEnable;/*  网络指示器的状态： 有网络 ： 开  没有网络： 关  */
    });
    return isNetworkEnable;
}
#pragma mark -- 处理json格式的字符串中的换行符、回车符
- (NSString *)deleteSpecialCodeWithStr:(NSString *)str {
    NSString *string = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    return string;
}
#pragma mark --根据返回的数据进行统一的格式处理
//----requestData 网络或者是缓存的数据----
- (void)returnDataWithRequestData:(NSData *)requestData Success:(SuccessBlock)success failure:(FailureBlock)failure{
    id myResult = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
    success (myResult);
}
#pragma mark  统一处理请求到的数据
-(void)dealWithResponseObject:(NSData *)responseData cacheUrl:(NSString *)cacheUrl cacheData:(id)cacheData isCache:(BOOL)isCache cache:(YYCache*)cache cacheKey:(NSString *)cacheKey success:(SuccessBlock)success failure :(FailureBlock)failure
{
    NSString * dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    dataString = [self deleteSpecialCodeWithStr:dataString];
    NSData *requestData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    if (isCache) {
        //设置缓存
        [cache setObject:requestData forKey:cacheKey];
    }
    //如果不缓存 或者 数据不相同 从网络请求
    if (!isCache || ![cacheData isEqual:requestData]) {
        [self returnDataWithRequestData:requestData Success:^(id responseObject) {
            success(responseObject);
        } failure:^(NSString *error) {
            failure(error);
        }];
    }
}
#pragma mark -- 网络请求统一处理
-(void)requestWithUrl:(NSString *)url withParamter:(id)parameters requestType:(RequestType)requestType  isCache:(BOOL)isCache  cacheKey:(NSString *)cacheKey imageKey:(NSString *)attach withData:(NSData *)data upLoadProgress:(LoadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure{
    //出来url的中文的问题
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *cacheUrl = [self urlDictToStringWithUrlStr:url WithDict:parameters];
    NSLog(@"最后的url:%@",cacheUrl);
    //设置YYCache属性
    YYCache *cache = [[YYCache alloc] initWithName:@"ZFCache"];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    id cacheData;
    if (isCache) {
        //根据网址从Cache中取数据
        cacheData = [cache objectForKey:cacheKey];
        if (cacheData != 0) {
            NSLog(@"第一步:先加载缓存");
            //将数据统一处理
            [self returnDataWithRequestData:cacheData Success:^(id responseObject) {
                NSLog(@"缓存的数据:%@",responseObject);
                success(responseObject);
            } failure:^(NSString *error) {
                
            }];
        }
    }
    //进行网络判断
    if (![self requestBeforeJudgeConnect]) {
        NSLog(@"第二步:网络未连接");
        failure(@"网络未连接");
        NSLog(@"网络未连接");
        return;
    }
    NSLog(@"第三步:继续请求，刷新数据，刷新缓存");
    //GET请求
    if (requestType == RequestTypeGet) {
        [session GET:cacheUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self dealWithResponseObject:responseObject cacheUrl:cacheUrl cacheData:cacheData isCache:isCache cache:cache cacheKey:cacheKey success:^(id responseObject) {
                success( responseObject);
            } failure:^(NSString *error) {
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            return;
        }];
    }
    //POST请求
    else if (requestType == RequestTypePost){
        [session POST:cacheUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            return;
        }];
    }
    //上传的图片
    else if (requestType == RequestTypeUpLoad){
        
    }
}
/**
 *  拼接post请求的网址
 *
 *  @param urlStr     基础网址
 *  @param parameters 拼接参数
 *
 *  @return 拼接完成的网址
 */
-(NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr WithDict:(NSDictionary *)parameters
{
    if (!parameters) {
        return urlStr;
    }
    NSMutableArray *parts = [NSMutableArray array];
    //enumerateKeysAndObjectsUsingBlock会遍历dictionary并把里面所有的key和value一组一组的展示给你，每组都会执行这个block 这其实就是传递一个block到另一个方法，在这个例子里它会带着特定参数被反复调用，直到找到一个ENOUGH的key，然后就会通过重新赋值那个BOOL *stop来停止运行，停止遍历同时停止调用block
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //接收key
        NSString *finalKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //接收值
        NSString *finalValue = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *part =[NSString stringWithFormat:@"%@=%@",finalKey,finalValue];
    
        [parts addObject:part];
    }];
    NSString *queryString = [parts componentsJoinedByString:@"&"];
    queryString = queryString ? [NSString stringWithFormat:@"?%@",queryString] : @"";
    NSString *pathStr = [NSString stringWithFormat:@"%@?%@",urlStr,queryString];
    return pathStr;
}
/*
 GET:不带缓存的请求
 Url:请求的url
 parameter:请求的参数
 success:请求成功的回调
 failure:请求失败的回调
 */
-(void)GETWithUrl:(NSString *)url parameter:(id)parameter success:(SuccessBlock)success failure:(FailureBlock)failure{
    [self requestWithUrl:url withParamter:parameter requestType:RequestTypeGet isCache:NO cacheKey:nil imageKey:nil withData:nil upLoadProgress:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSString *error) {
        failure(error);
    }];
}
@end
