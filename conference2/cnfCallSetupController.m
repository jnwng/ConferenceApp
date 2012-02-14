//
//  cnfCallSetupController.m
//  conference2
//
//  Created by Jonathan Wong on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cnfCallSetupController.h"
#import "cnfParticipantsController.h"
#import "cnfScheduleCallController.h"
#import "cnfAppDelegate.h"

@implementation cnfCallSetupController
@synthesize scheduleButton, callSetupTable, callTime, callTitle, callToUpdate, participantsArray, parent;
@synthesize callTitleTextField, callTimeCell;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CallCell"; 
    NSInteger row = [indexPath row];
    switch ([indexPath section]) {
        case 0:
            if (row == 0) {
                CellIdentifier = @"callTitleCell";
            }
            else if (row == 1) {
                CellIdentifier = @"callTimeCell";
            }
            else if (row == 2) {
                CellIdentifier = @"addContactsCell";
            }
            break;
        case 1:
            CellIdentifier = @"participantsCell";                
            break;
        default:
            break;
    }
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        
    }
    
    NSString *cellLabel = @"";
    
    // Get the object to display and set the value in the cell.
    if ([CellIdentifier isEqualToString:@"callTitleCell"]) {
        callTitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        callTitleTextField.adjustsFontSizeToFitWidth = YES;
        callTitleTextField.textColor = [UIColor blackColor];
        callTitleTextField.placeholder = @"Title of call";
        callTitleTextField.keyboardType = UIKeyboardTypeEmailAddress;
        callTitleTextField.returnKeyType = UIReturnKeyDone;
        callTitleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        callTitleTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; 
        callTitleTextField.textAlignment = UITextAlignmentRight;
        callTitleTextField.tag = 0;
        callTitleTextField.delegate = self;
        callTitleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [callTitleTextField setEnabled: YES];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:callTitleTextField];
        
        if (callToUpdate) {
            callTitleTextField.text = [callToUpdate valueForKey:@"title"];
            [self updateTitle:[callToUpdate valueForKey:@"title"]];
        }
        cellLabel = @"Title";
    }
    else if ([CellIdentifier isEqualToString:@"callTimeCell"]) {
        if (callToUpdate) {
            cellLabel = [self getStringFromDate:[callToUpdate valueForKey:@"time"]];
            [self updateTime:[callToUpdate valueForKey:@"time"]];
        }
        else {
            cellLabel = @"Date & Time";

        }
        callTimeCell = cell;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([CellIdentifier isEqualToString:@"addContactsCell"]) {
        cellLabel = @"Add Participants";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([CellIdentifier isEqualToString:@"participantsCell"]) {
        NSManagedObject *contact = [participantsArray objectAtIndex:[indexPath row]];
        cellLabel = [NSString stringWithFormat:@"%@ %@", [contact valueForKey:@"name"], [contact valueForKey:@"phone"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = cellLabel;
    
    
    
    cellLabel = nil;
    CellIdentifier = nil;  
    return cell;
}

- (IBAction) onDeleteCallClick {
    if(callToUpdate) {
    UIActionSheet *deleteCallDialog = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete this call? All records will be erased." 
                                                                  delegate:self 
                                                         cancelButtonTitle:@"Cancel" 
                                                    destructiveButtonTitle:@"Delete" 
                                                         otherButtonTitles:nil];
    deleteCallDialog.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [deleteCallDialog showInView:self.view];
    deleteCallDialog = nil;
    }
    
    else [self.navigationController popViewControllerAnimated:YES
          ]; 
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(buttonIndex) {
        case 0:
            [self deleteCall];
            break;
        case 1:
            break;
        default:
            break;
    }
}

- (void) deleteCall {
    if(callToUpdate) {
        [parent.callArray removeObjectIdenticalTo:callToUpdate];
        [parent deleteCall:callToUpdate];
        [parent updateCallList];
        [self.navigationController popViewControllerAnimated:YES];
        
        cnfAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        [context deleteObject:callToUpdate];
        NSError *error;
        [context save:&error];
        [self.parent updateCallList];
    }
    
    else [self.navigationController popViewControllerAnimated:YES];
} 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows;
    
    switch (section) {
        case 0: 
            rows = 3;
            break;
        case 1:
            rows = [participantsArray count];
            break;
        default:
            break;
    }
    return rows;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    switch([indexPath section]) {
        case 0:
            if (row == 0) {
            }
            else if (row == 1) {
                [self performSegueWithIdentifier:@"scheduleCallSegue" sender:self];
            }
            else if (row == 2) {
                [self performSegueWithIdentifier:@"addContactsSegue" sender:self];
            }
            break;
        case 1:
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text length] == 0) {
        [self updateTitle:@"Untitled"];
    }
    else {
        [self updateTitle:textField.text];
    }
}

- (void)updateTime: (NSDate *)date {
    callTime = date;
    callTimeCell.textLabel.text = [self getStringFromDate:date];
}

-(NSString *)getStringFromDate: (NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    df.dateFormat = @"ccc MMMM dd h:mm a";
    return [NSString stringWithFormat:@"%@", [df stringFromDate:date]];
}

- (void) updateTitle: (NSString *)title {
    callTitle = title;
    callTitleTextField.text = callTitle;
}

-(void) updateParticipants {
    [callSetupTable beginUpdates];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
    [callSetupTable reloadSections:indexSet withRowAnimation:YES];
    [callSetupTable endUpdates];
    
    if(participantsArray.count>0) self.callSetupTable.tableFooterView=myButtons;
    else self.callSetupTable.tableFooterView=nil;
}

- (void) onScheduleButtonClick {
    NSString *message;
    if (!callTitle) {
        [self updateTitle:@"Untitled"];
    }
    if (callToUpdate) {
        [parent updateCall:self withTitle:callTitle withTime:callTime withParticipants:participantsArray withOriginalCall:callToUpdate];
        callToUpdate = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        if (!callTime || [participantsArray count] == 0) {
            if (!callTime) {
                message = @"No time selected!";
            }
            else if ([participantsArray count] == 0) {
                message = @"No participants added!";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:message 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }
        else {
            [parent scheduleCall:self withTitle:callTitle withTime:callTime withParticipants:participantsArray];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

}

- (IBAction)callNow {
    [self updateTime:[[NSDate date] dateByAddingTimeInterval:-1]];
    [self onScheduleButtonClick];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
    if ([[segue identifier] isEqualToString:@"addContactsSegue"]) {
        cnfParticipantsController *participantsController = [segue destinationViewController];
        participantsController.parent = self;
    }
    else if ([[segue identifier] isEqualToString:@"scheduleCallSegue"]) {
        cnfScheduleCallController *scheduleCallController = [segue destinationViewController];
        scheduleCallController.parent = self;
        scheduleCallController.callTime = callTime;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    participantsArray = [[NSMutableArray alloc] init];
    if (callToUpdate) {
        NSSet *iterItems = [NSSet setWithSet:[callToUpdate valueForKey:@"participants"]];
        for (NSManagedObject *item in iterItems) { 
            [participantsArray addObject:item];
        }
        [self updateParticipants];
    }
    else {
        participantsArray = [[NSMutableArray alloc] init];
    }
    
    //[self.callSetupTable addSubview:deleteButton];
    
    //self.callSetupTable.tableFooterView= deleteButton;
    

        
    myButtons= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 135)];
    
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton addTarget:self 
                     action:@selector(onDeleteCallClick)
           forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    UIImage *deleteImage = [UIImage imageNamed: @"rjdoW.png"];
    [deleteButton setBackgroundImage:deleteImage forState: UIControlStateNormal];
    deleteButton.frame = CGRectMake(10, 70, 300.0, 60.0);
    deleteButton.userInteractionEnabled=YES;
    [myButtons addSubview:deleteButton];
    deleteButton.hidden=YES;
    
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [callButton addTarget:self 
                   action:@selector(callNow)
         forControlEvents:UIControlEventTouchUpInside];
    [callButton setTitle:@"Call Now" forState:UIControlStateNormal];
    UIImage *callImage = [UIImage imageNamed: @"IphoneButton_Green.png"];
    [callButton setBackgroundImage:callImage forState: UIControlStateNormal];
    callButton.frame = CGRectMake(10, 0, 300.0, 60.0);
    callButton.userInteractionEnabled=YES;
    [myButtons addSubview:callButton];
    myButtons.userInteractionEnabled=YES;
    
    if(callToUpdate) {
        deleteButton.hidden=NO;
        self.callSetupTable.tableFooterView = myButtons;
    }
}

/*- (UIView *)tableView:(UITableView *)tbleView viewForFooterInSection:(NSInteger)section {
    
    //if(tbleView!=callSetupTable) return nil;
    
    if(section==1) {
        myButtons= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        
        deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton addTarget:self 
                   action:@selector(callNow)
         forControlEvents:UIControlEventTouchDown];
        [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        UIImage *deleteImage = [UIImage imageNamed: @"rjdoW.png"];
        [deleteButton setBackgroundImage:deleteImage forState: UIControlStateNormal];
        deleteButton.frame = CGRectMake(10, 0, 300.0, 60.0);
        deleteButton.userInteractionEnabled=YES;
        [myButtons addSubview:deleteButton];
        
        UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [callButton addTarget:self 
                         action:@selector(callNow)
               forControlEvents:UIControlEventTouchDown];
        [callButton setTitle:@"Call Now" forState:UIControlStateNormal];
        UIImage *callImage = [UIImage imageNamed: @"IphoneButton_Green.png"];
        [callButton setBackgroundImage:callImage forState: UIControlStateNormal];
        callButton.frame = CGRectMake(10, 70, 300.0, 60.0);
        callButton.userInteractionEnabled=YES;
        [myButtons addSubview:callButton];
        myButtons.userInteractionEnabled=YES;
        
        /*[myButtons addSubview:deleteButton];
        [myButtons addSubview:callNowButton];
        myButtons.userInteractionEnabled = YES;
        
        myButtons.autoresizesSubviews = YES;
        myButtons.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        myButtons.userInteractionEnabled = YES;
        
        myButtons.hidden = NO;
        myButtons.multipleTouchEnabled = NO;
        myButtons.opaque = NO;
        myButtons.contentMode = UIViewContentModeScaleToFill;*/
        
        /*return myButtons;
    }
    
    else return nil;
}*/

- (void)viewDidUnload
{
    callTitleTextField = nil;
    [self setCallTitleTextField:nil];
    callTimeCell = nil;
    [self setCallTimeCell:nil];
    callSetupTable = nil;
    [self setCallSetupTable:nil];
    scheduleButton = nil;
    [self setScheduleButton:nil];
    participantsArray = nil;
    [self setParticipantsArray:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
