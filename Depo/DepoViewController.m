//
//  DepoViewController.m
//  Depo
//
//  Created by Samuel Drozdov on 11/1/14.
//  Copyright (c) 2014 MoonAnimals. All rights reserved.
//

#import "DepoViewController.h"
#import "PayPalPayment.h"
#import "ServerRequest.h"
#import <Chain.h>

@interface DepoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;
@property (weak, nonatomic) IBOutlet UITextField *userBitcoinPublicKeyTextField;

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@property (weak, nonatomic) IBOutlet UILabel *conversionLabel;


@property (strong, nonatomic) NSString * userBitcoinPublicKey;
@property (assign, nonatomic) float  sentAmount;

@property (strong, nonatomic) NSString * hashstring;

@end

@implementation DepoViewController {
    NSInteger countdownCounter;
    float bitcoinPrice;
    UITapGestureRecognizer *tap;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userBitcoinPublicKey = [NSString new];

    self.title = @"Depo";
    self.amountField.keyboardType=UIKeyboardTypeDecimalPad;
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.languageOrLocale = @"en";
    _payPalConfig.merchantName = @"Depo Bitcoin Bank";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _payPalConfig.rememberUser=YES;
    
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.successView.hidden = YES; //animation for when payment is successful
    self.environment = PayPalEnvironmentSandbox;

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    // Preconnect to PayPal early
    [PayPalMobile preconnectWithEnvironment:self.environment];

    
    //timer to refresh bitcoin value
    countdownCounter = 1;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    
    //text field mechanics - USD amount shows conversion to BTC
    self.amountField.delegate = self;
    self.userBitcoinPublicKeyTextField.delegate = self;
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    [self.amountField addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Text Field Mechanics

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:tap];
}

-(void)textFieldDidChange {
    [self updateConversionPrice];
}

-(void)dismissKeyboard {
    [self.amountField resignFirstResponder];
    [self.view removeGestureRecognizer:tap];
}

-(void)updateConversionPrice {
    if([self.amountField.text isEqual:@"0"] || [self.amountField.text isEqual:@" "]){
        self.amountField.text = @"";
    } else {
        float typedAmount = [self.amountField.text floatValue];
        self.conversionLabel.text = [NSString stringWithFormat:@"= %0.4f BTC", typedAmount/bitcoinPrice];
    }
}

#pragma mark - Update bitcoin price

-(void)countdown {
    countdownCounter--;
    if(countdownCounter == 0) {
        countdownCounter = 10;
        [self getBitcoinPrice];
    }
}

-(void)getBitcoinPrice {
    NSURL *url = [NSURL URLWithString:@"https://coinbase.com/api/v1/prices/spot_rate"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error != nil) {
            NSLog(@"Could not get bitcoin price with error:%@",error);
        } else {
            NSDictionary *spotPrice = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            bitcoinPrice = [[spotPrice objectForKey:@"amount"] floatValue];
        }
    }];
}

#pragma mark - Buttons

- (IBAction)sendTapped:(id)sender {
    
    self.userBitcoinPublicKey  = [self.userBitcoinPublicKeyTextField.text copy];
    self.sentAmount = [self.amountField.text floatValue];

    
    NSLog(@"User Public key: %@\nSent amount: %f", self.userBitcoinPublicKey, self.sentAmount);
    

    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    PayPalItem *item1 = [PayPalItem itemWithName:@"Bitcoin Transaction"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:self.amountField.text]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Bitcoin Transaction";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    payment.intent = PayPalPaymentIntentSale;
    
    if (!payment.processable) {
        
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}



#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    self.amountField.text=nil;
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    //self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\n Send this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
                                                           options:0
                                                             error:nil];
    
    ServerRequest *paymentRequest = [ServerRequest sharedManager];
    BOOL PayPalConfirmed=[paymentRequest postPayment:confirmation];
    if(PayPalConfirmed){
        [self startBitcoinTransaction];
    }
    
    
}

#pragma mark - start bitcoin transcation

-(void)startBitcoinTransaction{
    
    NSLog(@"start Bitcoin transcation");
    
}



- (void)showSuccess {
    self.successView.hidden = NO;
    self.successView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2.0];
    self.successView.alpha = 0.0f;
    [UIView commitAnimations];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
- (IBAction)mockSend:(id)sender
{
    
    //User public key : n2Q1BDERQ7voY4uzUYUQZNdHUsFwfw59ze
    NSString *preloadedUserPublicKey = @"n2Q1BDERQ7voY4uzUYUQZNdHUsFwfw59ze";
    
    //Master public key : moXoEC6RoMhdmqgtJxh5zWY5RDvXNpPE7t
    NSString *preloadedMasterPublicKey = @"moXoEC6RoMhdmqgtJxh5zWY5RDvXNpPE7t";
    
    //Master private key :044015ed16d308b54d5b213324abb3c3c7e54339b8cbda040fd4f7a1cf2e9c77aff26947bac96f7de1ac327131ea24ff3d8bbba85c9f336873b43c154005e4f678
    
//    NSString *preloadedMasterPrivateKey = @"044015ed16d308b54d5b213324abb3c3c7e54339b8cbda040fd4f7a1cf2e9c77aff26947bac96f7de1ac327131ea24ff3d8bbba85c9f336873b43c154005e4f678";
    
//    float predefinedSendAmount = 0.001;
    
    Chain *chain = [Chain sharedInstanceWithToken:@"b488bbdb6cb7fd80058b705fdeaac951"];
    
    [[Chain sharedInstance] setBlockChain:@"testnet3"];
    
    
    
    
    
    [chain getAddressTransactions:preloadedUserPublicKey completionHandler:^(NSDictionary *dictionary, NSError *error) {
        if (error)
        {
            NSLog(@"Chain error: %@", error);
        }
        else
        {
            NSArray * result = [dictionary objectForKey:@"results"];
            
            
            //self.hashstring is the previous transaction hash
            
            self.hashstring = [[result firstObject] objectForKey:@"hash"];
            
            NSLog(@"HASH %@", self.hashstring);
            
        }
    }];
    
    
//
//    [chain getAddressUnspents:preloadedMasterPublicKey completionHandler:^(NSDictionary *dictionary, NSError *error){
//        if(error) {
//            NSLog(@"error at AddressUnspents: %@", error);
//        } else {
//            NSArray *results = [dictionary objectForKey:@"results"];
//             NSString *transactionHash = [[results firstObject] objectForKey:@"transaction_hash"];
//            
//            NSLog(@"UNSPENTS Transaction hash: %@", transactionHash);
//            
//            [chain getTransaction:transactionHash completionHandler:^(NSDictionary *dictionary, NSError *error){
//                if(error) {
//                    NSLog(@"error at getTransaction: %@", error);
//                } else {
//                    
//                    NSLog(@"Transaction: %@", dictionary);
//                    
//                    /*
//                    NSString *realTransactionHash = [[dictionary objectForKey:@"outputs"] firstObject];
//                    NSLog(@"Real Transaction Hash: %@", realTransactionHash);
//                    
//                    [chain getTransactionOpReturn:realTransactionHash completionHandler:^(NSDictionary *dictionary, NSError *error){
//                        if(error) {
//                            NSLog(@"error at transactionOpReturn: %@", error);
//                        } else {
//                            
//                            NSLog(@"TransactionOpReturn %@", dictionary);
//                        }
//                        
//                        
//                    }];
//                     */
//                    
//                }
//            }];
//            
//            [chain getTransactionOpReturn:transactionHash completionHandler:^(NSDictionary *dictionary, NSError *error){
//                if(error) {
//                    NSLog(@"error at transactionOpReturn: %@", error);
//                } else {
//                    
//                    NSLog(@"TransactionOpReturn %@", dictionary);
//                }
//                
//                
//            }];
//        }
//    }];


    
    
}


@end
