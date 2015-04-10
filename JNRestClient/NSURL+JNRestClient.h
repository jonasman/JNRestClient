//
//  NSURL+JNRestClient.h
//  RestClientDemo
//
//  Created by Joao Nunes on 10/04/15.
//  Copyright (c) 2015 joao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (JNRestClient)

- (void)GETWithCompletionHandler:(void(^)(id result,NSError * error))handler;
- (void)POSTJson:(id/*<NSArray or NSDictionary>*/)json WithCompletionHandler:(void(^)(id result,NSError * error))handler;

@end
