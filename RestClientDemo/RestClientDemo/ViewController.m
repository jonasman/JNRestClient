//
//  ViewController.m
//  RestClientDemo
//
//  Created by Joao Nunes on 07/02/14.
//  Copyright (c) 2014 joao. All rights reserved.
//

#import "ViewController.h"
#import "JNRestClient.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *resultsTextView;
@property (nonatomic) JNRestClient * restClient;

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
    
    NSURL * url = [NSURL URLWithString:@"https://www.pcwebshop.co.uk"];
    
    __typeof(&*self) __weak weakSelf = self;

    self.restClient.method = RestMethodGet;
	self.restClient.ignoreCertificateValidation = YES;
    
    // Start our request to URL
    [self.restClient startWithURL:url andCompletionHandler:^(NSData *result,NSError * error) {
        
        // Convert our NSData to NSString
        NSString * results = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        
        // Update the UI
		if (error)
			weakSelf.resultsTextView.text = [error description];
		else
			weakSelf.resultsTextView.text = results;
        
        
    }];
    
}
- (IBAction)doPOST:(UIButton *)sender {
    
    
    
    NSURL * url = [NSURL URLWithString:@"https://public.opencpu.org/ocpu/library/"];
    
    __typeof(&*self) __weak weakSelf = self;
    
    self.restClient.method = RestMethodPost;

    // Add some NSData to the request
    self.restClient.postData = [@"Test" dataUsingEncoding:NSUTF8StringEncoding];
    
    // Start our POST request to URL
    [self.restClient startWithURL:url andCompletionHandler:^(NSData *result,NSError * error) {
        
        // Convert our NSData to NSString
        NSString * results = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        
        // Update the UI
		
		if (error)
			weakSelf.resultsTextView.text = [error description];
		else
			weakSelf.resultsTextView.text = results;
        
        
    }];
}


@end
