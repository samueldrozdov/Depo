//
//  FriendsTableViewController.m
//  Depo
//
//  Created by Phillip Ou on 11/2/14.
//  Copyright (c) 2014 MoonAnimals. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import "DepoViewController.h"



@interface FriendsTableViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *publicKeyField;
@property (strong, nonatomic) NSMutableDictionary *users;
@property (strong, nonatomic) NSMutableArray *usersArray;
@property (strong, nonatomic) User *selectedUser;



@end

@implementation FriendsTableViewController {
    
    __weak IBOutlet UIButton *addButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usersArray = [[NSMutableArray alloc]init];
    NSError *error;
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"User" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    self.usersArray = [fetchedObjects mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //make add button a circle
    addButton.clipsToBounds = YES;
    addButton.layer.cornerRadius = 40/2.0f;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.usersArray count];
}
- (IBAction)add:(id)sender {
    NSLog(@"called once");
    if(self.nameField.text.length>0 && self.publicKeyField.text.length>0){
        NSManagedObjectContext *managedObjectContext = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
        User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
        newUser.name = self.nameField.text;
        newUser.publicKey = self.publicKeyField.text;
        [self.usersArray addObject: newUser];
        //instantiate Candy object
        NSError *error = nil;
        [managedObjectContext save:&error]; //save the context and save to server
        self.nameField.text = nil;
        self.publicKeyField.text = nil;
        //if it couldn't save
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        [self.nameField resignFirstResponder];
        [self.publicKeyField resignFirstResponder];
        [self.tableView reloadData];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
    UILabel *nameLabel = (UILabel *) [cell viewWithTag:-1];
    UILabel *publicKeyLabel = (UILabel *) [cell viewWithTag:-2];
    User *user = [self.usersArray objectAtIndex:indexPath.row];
    nameLabel.text = user.name;
    publicKeyLabel.text = user.publicKey;
    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSError *error = nil;
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    [context deleteObject:[self.usersArray objectAtIndex:indexPath.row]];
    [context save:&error];
    
    // Delete the row from tableview
    [self.usersArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

NSIndexPath* lastIndexPath; // This as an ivar
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    User *selectedUser = [self.usersArray objectAtIndex:indexPath.row];
    self.selectedUser = selectedUser;
    [self.delegate selectedUser:selectedUser.publicKey];
    [self performSegueWithIdentifier:@"goBack" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"goBack"]){
        DepoViewController *other = [segue destinationViewController];
        other.publicKey = self.selectedUser.publicKey;
        
        
    }
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
