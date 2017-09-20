//
//  BaseService.h
//  iosdemo
//
//  Created by vnetoo on 2017/9/20.
//  Copyright © 2017年 vnetoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ServiceFinishBlock)(id result);
@interface BaseService : NSObject
+ (BaseService *)shareManager;

//get方法
-(void)getDataForGet:(NSString *)APIString
           parameter:(NSDictionary *)param
         finishBlock:(ServiceFinishBlock)finishBlock;

//post方法
-(void)getDataForPost:(NSString *)APIString
            parameter:(NSDictionary *)param
          finishBlock:(ServiceFinishBlock)finishBlock;

//附带文件的post方法 文件data数据流
-(void)getDataForPostWithFile:(NSString *)APIString
                    parameter:(NSDictionary *)param
                     fileData:(NSArray *)dataArray
                  finishBlock:(ServiceFinishBlock)finishBlock;

//附带文件的post方法 文件file
-(void)getDataForPostWithFile:(NSString *)APIString
                    parameter:(NSDictionary *)param
                     filePath:(NSArray *)pathArray
                  finishBlock:(ServiceFinishBlock)finishBlock;

//下载文件 返回文件地址
-(void)creatingDownloadTask:(NSString *)APIString
                finishBlock:(ServiceFinishBlock)finishBlock;
@end
