//
//  JLHttpClient.h
//  Ｏffduty
//
//  Created by ios-dev on 16/6/1.
//  Copyright © 2016年 com.jl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLHttpClient : NSObject

+(NSDictionary *)queryErpData:(NSString *)urlhr queryData:  (NSDictionary *) dictionary;
@end
