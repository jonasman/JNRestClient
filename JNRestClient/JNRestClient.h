//
//  RestClient.h
//
//
//  Created by Joao Nunes on 12/07/13.
//  https://github.com/jonasman/JNRestClient
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, RestMethod)
{
    RestMethodPost,
    RestMethodGet
};


@interface JNRestClient : NSObject

@property (nonatomic,readonly) NSURL * url;

@property (nonatomic) RestMethod method; // Defaults to GET
@property (nonatomic) NSData * data;


@property (nonatomic) BOOL ignoreCertificateValidation; // Defaults to NO



- (void)startWithURL:(NSURL *)url andCompletionHandler:(void(^)(NSData * result,NSError * error))handler;// Completion handler will be called in a background Queue

@end
