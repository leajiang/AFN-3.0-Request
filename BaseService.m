//
//  BaseService.m
//  iosdemo
//
//  Created by vnetoo on 2017/9/20.
//  Copyright © 2017年 vnetoo. All rights reserved.
//

#import "BaseService.h"
#import "AFNetworking.h"

@implementation BaseService

static BaseService * singleton = nil;
+ (instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    @synchronized(self)
    {
        if(singleton == nil)
        {
            dispatch_once(&onceToken, ^{
                singleton = [[BaseService alloc] init];
            });
        }
    }
    return singleton;
}


- (AFSecurityPolicy *)customSecurityPolicy {
    // 先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];//证书的路径
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    NSSet *cerDataSet = [NSSet setWithArray:@[cerData]];
    securityPolicy.pinnedCertificates = cerDataSet;
    
    return securityPolicy;
}

//get方法
-(void)getDataForGet:(NSString *)APIString
           parameter:(NSDictionary *)param
         finishBlock:(ServiceFinishBlock)finishBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [self customSecurityPolicy];
    [manager GET:APIString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (finishBlock) {
            finishBlock(responseObject);
        }
        NSLog(@"\n请求链接:%@\n请求参数:%@\n请求结果:%@",APIString,param,responseObject);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        if (finishBlock) {
            finishBlock(nil);
        }
        NSLog(@"请求失败：error＝%@",error);
        NSLog(@"\n请求链接:%@\n请求参数:%@",APIString,param);
        
    }];
    
}
//附带文件的post方法
-(void)getDataForPost:(NSString *)APIString
            parameter:(NSDictionary *)param
          finishBlock:(ServiceFinishBlock)finishBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [self customSecurityPolicy];
    [manager POST:APIString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (finishBlock) {
            finishBlock(responseObject);
        }
        NSLog(@"\n请求链接:%@\n请求参数:%@\n请求结果:%@",APIString,param,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(nil);
        }
        NSLog(@"请求失败：error＝%@",error);
        NSLog(@"\n请求链接:%@\n请求参数:%@",APIString,param);
    }];
}
//附带文件的post方法 文件data数据流
-(void)getDataForPostWithFile:(NSString *)APIString
                    parameter:(NSDictionary *)param
                     fileData:(NSArray *)dataArray
                  finishBlock:(ServiceFinishBlock)finishBlock{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [self customSecurityPolicy];
    
    [manager POST:APIString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        [formData appendPartWithFileData:dataArray[0] name:@"file" fileName:@"xxx.png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        if (finishBlock) {
            finishBlock(responseObject);
        }
        NSLog(@"\n请求链接:%@\n请求参数:%@\n请求结果:%@",APIString,param,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (finishBlock) {
            finishBlock(nil);
        }
        NSLog(@"请求失败：error＝%@",error);
        NSLog(@"\n请求链接:%@\n请求参数:%@",APIString,param);
    }];
    
}
-(void)getDataForPostWithFile:(NSString *)APIString
                    parameter:(NSDictionary *)param
                     filePath:(NSArray *)pathArray
                  finishBlock:(ServiceFinishBlock)finishBlock{

   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [self customSecurityPolicy];
    [manager POST:APIString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:pathArray[0]] name:@"file" fileName:@"xxx.png" mimeType:@"application/octet-stream" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        if (finishBlock) {
            finishBlock(responseObject);
        }
        NSLog(@"\n请求链接:%@\n请求参数:%@\n请求结果:%@",APIString,param,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (finishBlock) {
            finishBlock(nil);
        }
        NSLog(@"请求失败：error＝%@",error);
        NSLog(@"\n请求链接:%@\n请求参数:%@",APIString,param);
    }];

}
//下载文件
-(void)creatingDownloadTask:(NSString *)APIString
                finishBlock:(ServiceFinishBlock)finishBlock{

    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [self customSecurityPolicy];
    //2.确定请求的URL地址
    NSURL *url = [NSURL URLWithString:@""];
    
    //3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //打印下下载进度
        NSLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //下载地址
        NSLog(@"默认下载地址:%@",targetPath);
        
        //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        return [NSURL fileURLWithPath:filePath];
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        //下载完成调用的方法
        if (finishBlock) {
            finishBlock(filePath);
        }
        NSLog(@"File downloaded to: %@", filePath);
       
    }];
    
    //开始启动任务
    [task resume];
    
}

- (void)AFNetworkStatus{
    
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                
                break;
                
            default:
                break;
        }
        
    }] ;
}


@end
