//
//  DepoViewController.m
//  Depo
//
//  Created by Samuel Drozdov on 11/1/14.
//  Copyright (c) 2014 MoonAnimals. All rights reserved.
//

#import "DepoViewController.h"

@interface DepoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *conversionLabel;

@end

@implementation DepoViewController {
    NSInteger countdownCounter;
    float bitcoinPrice;
    UITapGestureRecognizer *tap;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //timer to refresh bitcoin value
    countdownCounter = 3;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    
    //text field mechanics - USD amount shows conversion to BTC
    self.amountField.delegate = self;
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
}

#pragma mark - Text Field Mechanics

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.amountField resignFirstResponder];
    float typedAmount = [self.amountField.text floatValue];
    self.conversionLabel.text = [NSString stringWithFormat:@"= %.03f BTC", typedAmount/bitcoinPrice];
    [self.view removeGestureRecognizer:tap];
}

#pragma mark - Update bitcoin price

-(void)countdown {
    countdownCounter--;
    if(countdownCounter == 0) {
        NSLog(@"Counter Reset");
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
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
