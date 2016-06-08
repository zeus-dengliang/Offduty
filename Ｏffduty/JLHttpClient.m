//
//  JLHttpClient.m
//  Ｏffduty
//
//  Created by ios-dev on 16/6/1.
//  Copyright © 2016年 com.jl. All rights reserved.
//

#import "JLHttpClient.h"

@implementation JLHttpClient
//查询数据
+(NSDictionary *)queryErpData:(NSString *)urlhr: (NSDictionary *) dictionary;
{
    // 1.URL
    NSURL *url = [NSURL URLWithString:urlhr];
    // 2.请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 3.请求方法
    request.HTTPMethod = @"POST";
    // 4.设置请求体（请求参数）
    // 创建一个描述订单信息的JSON数据
    NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = json;
    //NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    // 5.设置请求头：这次请求体的数据不再是普通的参数，而是一个JSON数据
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 6.发送一个同步请求
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (data == nil || error) return nil;
    
    NSString *tmp=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",tmp);
    // 解析服务器返回的JSON数据
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //NSString *success = [dict objectForKey:@"message"];
    return dict;
}
@end
