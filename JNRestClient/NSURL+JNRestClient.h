//
//  NSURL+JNRestClient.h
//  RestClientDemo
//
//  Created by Joao Nunes on 10/04/15.
//  Copyright (c) 2015 joao. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const JNRestClientHEADERS_KEY; // NSDictionary
extern NSString * const JNRestClientIGNORE_CERT_KEY; // NSNumber, BOOL

@interface NSURL (JNRestClient)

/**
 *  GET Method
 *
 *  Performs a GET command in the URL
 *
 *  @param handler completion handler, returns a parsed JSON response
 */

- (void)GETWithCompletionHandler:(void(^)(id result,NSError * error))handler;
/**
 *  GET Method with options
 *
 *  Performs a GET command in the URL with options
 *
 *  @param options options dictionary
 *  @param handler completion handler, returns a parsed JSON response
 */
- (void)GETWithOptions:(NSDictionary *)options completionHandler:(void(^)(id result,NSError * error))handler;


/**
 *  POST Method
 *
 *  Performs a POST command in the URL
 *
 *  @param json    json data to post
 *  @param handler completion handler, returns parsed JSON response
 */
- (void)POSTJson:(id)json withCompletionHandler:(void(^)(id result,NSError * error))handler;

/**
 *  POST Method
 *
 *  Performs a POST command in the URL with options
 *
 *  @param json    json data to post
 *  @param options options dictionary
 *  @param handler completion handler, returns parsed JSON response
 */
- (void)POSTJson:(id)json options:(NSDictionary *)options withCompletionHandler:(void(^)(id result,NSError * error))handler;

/**
 *  Cancels current request
 *
 */
- (void)cancelRequest;

@end
