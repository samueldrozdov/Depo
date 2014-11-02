//
//  BlockChainViewController.m
//  Depo
//
//  Created by Luke Solomon on 11/2/14.  //  Copyright (c) 2014 MoonAnimals. All rights reserved.
//

#import "BlockChainViewController.h"

@interface BlockChainViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *blockChainWebView;
@property (weak, nonatomic) IBOutlet UITextField *publicKeyAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *userKeyAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
- (IBAction)showMeTheMoneyButton:(id)sender;

@end

@implementation BlockChainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _publicKeyAddressTextField.text = @"1B9JKx7PCFqRYejzdV8ig3mS4VMPTgVLkq";
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


- (IBAction)showMeTheMoneyButton:(id)sender {

    //api prep code
    NSString *userWalletPublicKey = _userKeyAddressTextField.text;
    NSString *amount = _amountTextField.text;
    
    NSString *prepString = [NSString stringWithFormat:@"https://blockchain.info/merchant/2526006c-8a8b-47a3-ab37-4f9b6eff5e39/payment?password=%262N86363%5E1  82986ZNze8&to= %@ &amount= %@", userWalletPublicKey, amount];
    
    //webview code
    //NSString *fullURL = @"http://conecode.com";
    //NSURL *url = [NSURL URLWithString:fullURL];
    
    NSURL *url = [NSURL URLWithString:prepString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_blockChainWebView loadRequest:requestObj];
}


@end
