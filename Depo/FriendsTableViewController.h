//
//  FriendsTableViewController.h
//  Depo
//
//  Created by Phillip Ou on 11/2/14.
//  Copyright (c) 2014 MoonAnimals. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol selectedUserDelegate
-(void)selectedUser:(NSString*)publicKey;
@end

@interface FriendsTableViewController : UITableViewController<selectedUserDelegate,UITextFieldDelegate>
@property (strong, nonatomic) id <selectedUserDelegate> delegate;

@end
