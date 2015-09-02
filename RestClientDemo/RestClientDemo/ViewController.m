//
//  ViewController.m
//  RestClientDemo
//
//  Created by Joao Nunes on 07/02/14.
//  Copyright (c) 2014 joao. All rights reserved.
//

#import "ViewController.h"
#import "JNRestClient.h"
#import "NSURL+JNRestClient.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *resultsTextView;
@property (nonatomic) JNRestClient * restClient;
@property (nonatomic) NSURL * url;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Create our RestClient
    self.restClient = [[JNRestClient alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions

/*
  From: http://resttesttest.com
 
 */

- (IBAction)doGET:(UIButton *)sender
{
    
    self.url = [NSURL URLWithString:@"http://www.telize.com/jsonip"];
    
    __typeof(&*self) __weak weakSelf = self;
	
	/*
	 // Method 1
	 
	 self.restClient.method = RestMethodGet;
	 self.restClient.ignoreCertificateValidation = YES;
	 
	 // Start our request to URL
	 [self.restClient startWithURL:self.url andCompletionHandler:^(NSData *result,NSError * error) {
	 
	 // Convert our NSData to NSString
	 NSString * results = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
		
		// Update the UI in Main queue
		dispatch_async(dispatch_get_main_queue(), ^{
	 
	 if (error)
	 weakSelf.resultsTextView.text = [error description];
	 else
	 weakSelf.resultsTextView.text = results;
		});
	 
	 
	 }];
	 */
	
	// Method 2
	NSDictionary * options = @{JNRestClientHEADERS_KEY: @{@"X":@"TEST"}};
	
	[self.url GETWithOptions:options completionHandler:^(id result, NSError *error) {
		
        NSLog(@"Result: %@",result);
        
    }];
    
    
    
}
- (IBAction)doPOST:(UIButton *)sender {
    
    
    
    self.url = [NSURL URLWithString:@"http://jsonplaceholder.typicode.com/posts"];
    
    __typeof(&*self) __weak weakSelf = self;
	
	
	NSDictionary * json = @{@"title":@"foo",
							@"body":@"barr",
							@"userId":@1};
	
	/*
	 // Method 1
    self.restClient.method = RestMethodPost;

    
    // Add some NSData to the request
    self.restClient.postData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    
    // Start our POST request to URL
    [self.restClient startWithURL:self.url andCompletionHandler:^(NSData *result,NSError * error) {
        
        // Convert our NSData to NSString
        NSString * results = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        
        // Update the UI in main queue
		dispatch_async(dispatch_get_main_queue(), ^{
			if (error)
				weakSelf.resultsTextView.text = [error description];
			else
				weakSelf.resultsTextView.text = results;
		});
        
        
    }];
	 */
	
	// Method 2
    [self.url POSTJson:json withCompletionHandler:^(id result, NSError *error) {

		dispatch_async(dispatch_get_main_queue(), ^{
			
			
			if (error)
				weakSelf.resultsTextView.text = [error description];
			else
				weakSelf.resultsTextView.text = [result description];
		});
        
    }];
	
	
}

- (IBAction)cancelAction:(id)sender {
	
	[self.url cancelRequest];
}

@end
