//
//  NSURL+JNRestClient.m
//  RestClientDemo
//
//  Created by Joao Nunes on 10/04/15.
//  Copyright (c) 2015 joao. All rights reserved.
//

#import "NSURL+JNRestClient.h"

@interface NSURL () <NSURLSessionDelegate>

@end

@implementation NSURL (JNRestClient)

- (void)GETWithCompletionHandler:(void(^)(id result,NSError * error))handler
{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue new]];
    
    NSURLSessionDataTask * dataTask =
    [defaultSession dataTaskWithURL:self
                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      
                      id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                      
                      handler(json,error);
                      
                  }];
    
    [dataTask resume];
    
}

- (void)POSTJson:(id)json WithCompletionHandler:(void(^)(id result,NSError * error))handler
{
 
    NSError * error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
    if (error)
    {
        handler(nil,error);
    }
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue new]];
   
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)jsonData.length];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:jsonData];
    
    NSURLSessionDataTask * dataTask =
    [defaultSession uploadTaskWithRequest:request fromData:jsonData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        handler(json,error);
        
    }];
    
    [dataTask resume];
    
}

#pragma mark URLSession delegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    if (YES)//self.ignoreCertificateValidation)
        completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust])
        ;
    else
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust])
        ;
}

@end
