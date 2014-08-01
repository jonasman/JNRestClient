//
//  RestClient.m
//
//
//  Created by Joao Nunes on 12/07/13.
//  https://github.com/jonasman/JNRestClient
//

#import "JNRestClient.h"

@interface JNRestClient () <NSURLSessionDelegate>

@property (nonatomic) NSURL * url;

@end

@implementation JNRestClient
{
    NSURLConnection * conn;
	NSURLSession * session;
    NSData * dataReceived;
}

- (id)init
{
    self = [super init];
    if (self) {
        _method = RestMethodGet;
        _ignoreCertificateValidation = NO;
    }
    return self;
}

- (void)startWithURL:(NSURL *)url andCompletionHandler:(void(^)(NSData * result,NSError * error))handler
{
    
    self.url = url;
    
    __typeof(&*self) __weak weakSelf = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
		NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
		NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
		
        
        if (weakSelf.method == RestMethodGet)
        {
			
			NSURLSessionDataTask * dataTask =
			[defaultSession dataTaskWithURL:self.url
						  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
							  
							  handler(data,error);
							  
						  }];
			
			[dataTask resume];

        }
		
        else if(weakSelf.method == RestMethodPost)
        {
			NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[self.postData length]];
			
			
			NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.url];
			
			[request setHTTPMethod:@"POST"];
			[request setValue:postLength forHTTPHeaderField:@"Content-length"];
			[request setHTTPBody:self.postData];
			
			NSURLSessionDataTask * dataTask =
			[defaultSession uploadTaskWithRequest:request fromData:self.postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
				handler(data,error);
			}];
			
			[dataTask resume];

        }

        
        
    });
}

#pragma mark URLSession delegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
	if (self.ignoreCertificateValidation)
		completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust])
		;
	else
		completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust])
		;
}



@end
