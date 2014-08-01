//
//  RestClient.m
//
//
//  Created by Joao Nunes on 12/07/13.
//  https://github.com/jonasman/JNRestClient
//

#import "JNRestClient.h"

@interface JNRestClient ()

@property (nonatomic) NSURL * url;

@end

@implementation JNRestClient
{
    NSURLConnection * conn;
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
        
        
        NSData * serverResponse;
        NSError * errorFromResponse;
        
        if (weakSelf.method == RestMethodGet)
        {
            serverResponse = [weakSelf doGetRequestError:&errorFromResponse];
        }
        else if(weakSelf.method == RestMethodPost)
        {
            serverResponse = [weakSelf doPostRequest:&errorFromResponse];
        }
        
        
        
        if (serverResponse && handler)
        {
            handler(serverResponse,errorFromResponse);
        }
        
        
    });
}

#pragma mark Get and Post requests

- (NSData *)doGetRequestError:(NSError **)error
{
    
    NSData * serverResponse = [NSData dataWithContentsOfURL:self.url options:NSDataReadingUncached error:error];
    
    if (*error)
        NSLog(@"GET Error: %@",*error);
    
    return serverResponse;
}


- (NSData *)doPostRequest:(NSError **)error
{
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[self.data length]];
 
 
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.url];
 
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:self.data];
 
 


    
    if (!self.ignoreCertificateValidation)
    {
        // if We dont need to ignore the certificate we can use the sync mode
        NSHTTPURLResponse * response;
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
        
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
    
    while (!dataReceived) {}
    
    return dataReceived;
}

#pragma mark Connection delegeate to ignore the server certificate error
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@",error);
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{

        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] ;
 
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    dataReceived  = data;
}



@end
