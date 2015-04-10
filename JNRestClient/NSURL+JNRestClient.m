//
//  NSURL+JNRestClient.m
//  RestClientDemo
//
//  Created by Joao Nunes on 10/04/15.
//  Copyright (c) 2015 joao. All rights reserved.
//

#import "NSURL+JNRestClient.h"

@implementation NSURL (JNRestClient)

- (void)GETWithCompletionHandler:(void(^)(NSData * result))handler
{
    
}

- (void)POSTJson:(id/*<NSArray or NSDictionary>*/)json WithCompletionHandler:(void(^)(NSData * result))handler
{
    
    __weak typeof(self)weakSelf = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)jsonData.length];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:weakSelf];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:jsonData];
        
        if (YES)//!self.ignoreCertificateValidation)
        {
            // if We dont need to ignore the certificate we can use the sync mode
            NSError * error;
            NSHTTPURLResponse * response;
            NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            dataReceived = data;
            
            // if (error) NSLog(@"POST Error: %@",error);
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
                [conn scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
                [conn start];
                
            });
        }

        
    });
}

@end
