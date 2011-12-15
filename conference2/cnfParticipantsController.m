//
//  cnfParticipantsController.m
//  conference2
//
//  Created by Jonathan Wong on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cnfParticipantsController.h"
#import "cnfAppDelegate.h"


@implementation cnfParticipantsController
@synthesize addContactsButton;
@synthesize navBar, participantsTable, recentContactsArray;

- (IBAction) onAddContactClick {
    UIActionSheet *addContactDialog = [[UIActionSheet alloc] initWithTitle:@"Choose an existing contact, or add a new one" 
                                                                  delegate:self 
                                                         cancelButtonTitle:@"Cancel" 
                                                    destructiveButtonTitle:nil 
                                                         otherButtonTitles:@"Add Existing Contact", @"Add New Contact", nil];
    addContactDialog.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [addContactDialog showInView:self.view];
    addContactDialog = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(buttonIndex) {
        case 0:
            [self showExistingContacts];
            break;
        case 1:
//            [self showNewContact];
            break;
        default:
            break;
    }
}

- (void) addContact:id withName:(NSString *)name withPhoneNumber:(NSString *)phoneNumber {
    if (![self checkDuplicateContact:self withPhoneNumber:phoneNumber]) {
        NSManagedObject *person = [self saveRecentContact:self withName:name withPhoneNumber:phoneNumber];
    
        [recentContactsArray addObject:person];
        NSIndexPath *rowIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *insertIndexPaths = [NSArray arrayWithObjects:rowIndex,nil];
    
        [participantsTable beginUpdates];
        [participantsTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
        [participantsTable endUpdates];
    
        rowIndex = nil;
        insertIndexPaths = nil;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Duplicate participant added!" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
}

- (NSManagedObject *) saveRecentContact:id withName:(NSString *)name withPhoneNumber:(NSString *)phoneNumber {
    cnfAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newContact;
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contacts" inManagedObjectContext:context];
    [newContact setValue:name forKey:@"name"];
    [newContact setValue:phoneNumber forKey:@"phone"];
    NSError *error;
    [context save:&error];
    return newContact;
}

- (void) loadRecentContacts {
    cnfAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = 
    [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)", name.text];
//    [request setPredicate:pred];
//    NSManagedObject *matches = nil;
    NSError *error;
    recentContactsArray = [[context executeFetchRequest:request error:&error] mutableCopy];
    if ([recentContactsArray count] == 0) {
//        status.text = @"No matches";
    }
}

- (BOOL) checkDuplicateContact:id withPhoneNumber:(NSString *)phoneNumber {
    
    cnfAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = 
    [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"phone = %@", phoneNumber];
    [request setPredicate:pred];
    NSError *error;
    NSArray *contacts = [[context executeFetchRequest:request error:&error] mutableCopy];
    return [contacts count] != 0;
}

- (void)showNewContact {
    [self performSegueWithIdentifier:@"addNewContactSegue" sender:self];
}

- (void) showExistingContacts {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentModalViewController:picker animated:YES];
    picker = nil;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker 
      shouldContinueAfterSelectingPerson:(ABRecordRef)person 
                                property:(ABPropertyID)property 
                              identifier:(ABMultiValueIdentifier)identifier{
    
    // We need to check the length of the phone number so we don't dismiss the modal too early
    if (property == kABPersonPhoneProperty) {
        NSString *originalPhoneNumber;
        ABMultiValueRef multi = ABRecordCopyValue(person, property);
        CFIndex theIndex = ABMultiValueGetIndexForIdentifier(multi, identifier);
        originalPhoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multi, theIndex);
        NSMutableString *strippedPhoneNumber = [NSMutableString stringWithCapacity:originalPhoneNumber.length];
        
        NSScanner *scanner = [NSScanner scannerWithString:originalPhoneNumber];
        NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        while ([scanner isAtEnd] == NO) {
            NSString *buffer;
            if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
                [strippedPhoneNumber appendString:buffer];
                
            } else {
                [scanner setScanLocation:([scanner scanLocation] + 1)];
            }
            buffer = nil;
        }
        
        CFRelease(multi);
        originalPhoneNumber = nil;
        scanner = nil;
        numbers = nil;
        
        if ([strippedPhoneNumber length] == 10) {
            NSMutableString* name = [(__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty) mutableCopy];
            [name appendString:@" "];
            [name appendString:(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty)];
            [self addContact:self withName:name withPhoneNumber:strippedPhoneNumber];
            [self dismissModalViewControllerAnimated:YES];
            strippedPhoneNumber = nil;
            return NO;
        }           
        strippedPhoneNumber = nil;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadRecentContacts];
}

- (void)viewDidUnload
{
    navBar = nil;
    [self setNavBar:nil];
    participantsTable = nil;
    [self setParticipantsTable:nil];
    recentContactsArray = nil;
    [self setRecentContactsArray:nil];
    addContactButton = nil;
    [self setAddContactsButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"participantsCell";
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    //    // Get the object to display and set the value in the cell.
    NSManagedObject *contact = [recentContactsArray objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [contact valueForKey:@"name"], [contact valueForKey:@"phone"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [recentContactsArray count];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
