//
//  DepoViewController.h
//  Depo
//
//  Created by Samuel Drozdov on 11/1/14.
//  Copyright (c) 2014 MoonAnimals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "PayPalConfiguration.h"

@class PayPalPaymentViewController;
typedef void (^PayPalPaymentDelegateCompletionBlock)(void);

/// Exactly one of these two required delegate methods will get called when the UI completes.
/// You MUST dismiss the modal view controller from these required delegate methods.
@protocol PayPalPaymentDelegate <NSObject>
@required

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController;

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment;

@optional
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                willCompletePayment:(PayPalPayment *)completedPayment
                    completionBlock:(PayPalPaymentDelegateCompletionBlock)completionBlock;
@end



@interface DepoViewController : UIViewController<PayPalPaymentDelegate,UITextFieldDelegate>

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;

- (instancetype)initWithPayment:(PayPalPayment *)payment
                  configuration:(PayPalConfiguration *)configuration
                       delegate:(id<PayPalPaymentDelegate>)delegate;
@property(nonatomic, weak, readonly) id<PayPalPaymentDelegate> paymentDelegate;
@property(nonatomic, assign, readonly) PayPalPaymentViewControllerState state;

@end
