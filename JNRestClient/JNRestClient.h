//
//  RestClient.h
//
//
//  Created by Joao Nunes on 12/07/13.
//
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, RestMethod)
{
    RestMethodPost,
    RestMethodGet
};


@interface JNRestClient : NSObject

@property (nonatomic) NSURL * url;
@property (nonatomic) RestMethod method; // Default GET
@property (nonatomic) NSData * data;

@property (nonatomic) BOOL ignoreCertificateValidation; // Default NO

- (void)startWithCompletionHandler:(void(^)(NSData * result))handler;

@end
