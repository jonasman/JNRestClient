//
//  NSURL+JNRestClient.m
//  RestClientDemo
//
//  Created by Joao Nunes on 10/04/15.
//  Copyright (c) 2015 joao. All rights reserved.
//


static char const * const currentTaskKey = "currentTaskKey";


NSString * const JNRestClientHEADERS_KEY = @"JNRestClientHEADERS_KEY";
NSString * const JNRestClientIGNORE_CERT_KEY = @"JNRestClientIGNORE_CERT_KEY";

NSString * const JNRESTCLIENT_INVALID_CERT = @"JNRESTCLIENT_INVALID_CERT";

#import "NSURL+JNRestClient.h"
#import <objc/runtime.h>

@interface NSURL () <NSURLSessionDelegate>

@property (nonatomic) NSURLSessionTask * currentTask;

@end

@implementation NSURL (JNRestClient)

#pragma mark Property

- (NSURLSessionTask *)currentTask {
	return objc_getAssociatedObject(self, currentTaskKey);
}

- (void)setCurrentTask:(NSURLSessionTask *)currentTask {
	objc_setAssociatedObject(self, currentTaskKey, currentTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark GET
- (void)GETWithCompletionHandler:(void(^)(id result,NSError * error))handler
{
	[self GETWithOptions:nil completionHandler:handler];
}
- (void)GETWithOptions:(NSDictionary *)options completionHandler:(void(^)(id result,NSError * error))handler
{
	[self performMethod:@"GET" withJson:nil options:options withCompletionHandler:handler];
}

#pragma mark POST
- (void)POSTJson:(id)json withCompletionHandler:(void(^)(id result,NSError * error))handler
{
	[self POSTJson:json options:nil withCompletionHandler:handler];
}

- (void)POSTJson:(id)json options:(NSDictionary *)options withCompletionHandler:(void(^)(id result,NSError * error))handler
{
	[self performMethod:@"POST" withJson:json options:options withCompletionHandler:handler];
}
#pragma mark Cancel

- (void)cancelRequest
{
	[self.currentTask cancel];
}

#pragma mark Common
- (void)performMethod:(NSString *)method withJson:(id)json options:(NSDictionary *)options withCompletionHandler:(void(^)(id result,NSError * error))handler
{
	
	NSData * jsonData;
	
	if (json)
	{
		NSError * error;
		jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
		if (error)
		{
			handler(nil,error);
		}
	}
	
	
	
	NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
	NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue new]];
	
	NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)jsonData.length];
	
	
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self];
	[request setHTTPMethod:method];
	
	
	
	NSDictionary * headers = options[JNRestClientHEADERS_KEY];
	if (headers && [headers isKindOfClass:[NSDictionary class]])
	{
		for (NSString * key in headers) {
			[request addValue:headers[key] forHTTPHeaderField:key];
		}
	}
	
	if (jsonData){
		[request setValue:postLength forHTTPHeaderField:@"Content-length"];
		[request setHTTPBody:jsonData];
	}
	
	
	
	void (^completionHandler)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {
		
		id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
		handler(json,error);
		
	};
	
	
	if ([method isEqualToString:@"POST"])
	{
		NSURLSessionDataTask * uploadDataTask =
		[defaultSession uploadTaskWithRequest:request fromData:jsonData completionHandler:completionHandler];
		
		self.currentTask = uploadDataTask;
	}
	else if ([method isEqualToString:@"GET"])
	{
		self.currentTask  =
		[defaultSession dataTaskWithRequest:request completionHandler:completionHandler];
		
	}
	
	BOOL invalidCert = [options[JNRestClientIGNORE_CERT_KEY] boolValue];
	if (invalidCert)
		self.currentTask.taskDescription = JNRESTCLIENT_INVALID_CERT;
	
	[self.currentTask  resume];
	
}

#pragma mark URLSession delegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
	BOOL ignoreCertificate = [task.taskDescription isEqualToString:JNRESTCLIENT_INVALID_CERT];
	
	if (ignoreCertificate)
		completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
	else
		completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

@end
