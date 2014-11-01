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

@end

@implementation DepoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
