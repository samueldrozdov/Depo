//
//  ServerRequest.m
//  Depo
//
//  Created by Phillip Ou on 11/1/14.
//  Copyright (c) 2014 MoonAnimals. All rights reserved.
//

#import "ServerRequest.h"

@implementation ServerRequest{
    BOOL PayPalComplete;
}
+ (id)sharedManager {
    static ServerRequest *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}


-(BOOL) postPayment:(NSData*)payment{
    PayPalComplete=NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURL *url = [NSURL URLWithString: @"https://api.paypal.com/v1/payments/payment"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSError *error = nil;
   // NSData *data = [NSJSONSerialization dataWithJSONObject:payment options:kNilOptions error:&error];
    if(!error){
        NSURLSessionUploadTask *uploadTask = [urlSession uploadTaskWithRequest:request fromData:payment completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"payment successful");
            PayPalComplete = YES;
            
             dispatch_semaphore_signal(semaphore);
            
        }];
        [uploadTask resume];
        
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"Pay:%d",PayPalComplete);
    return PayPalComplete;
}

@end
