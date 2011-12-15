//
//  cnfCallSetupController.m
//  conference2
//
//  Created by Jonathan Wong on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cnfCallSetupController.h"
#import "cnfParticipantsController.h"

@implementation cnfCallSetupController
@synthesize doneButton, callSetupTable, callTime, callTitle, participantsArray;

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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    NSString *cellLabel = @"";
    
    // Get the object to display and set the value in the cell.
    if ([CellIdentifier isEqualToString:@"callTitleCell"]) {
        if (!callTitle) {
            callTitle = [[NSMutableString alloc] initWithString:@"Untitled"];
        }
        cellLabel = callTitle;
    }
    else if ([CellIdentifier isEqualToString:@"callTimeCell"]) {
//        if (callTime) {
////            [self updateTime:callTime];
//        }
//        else {
            cellLabel = @"Date & Time";
//        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([CellIdentifier isEqualToString:@"addContactsCell"]) {
        cellLabel = @"Add Contacts";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([CellIdentifier isEqualToString:@"participantsCell"]) {
//        cellLabel = [participants;
    }
    
    cell.textLabel.text = cellLabel;
    
    cellLabel = nil;
    CellIdentifier = nil;
    return cell;
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
    if ([[segue identifier] isEqualToString:@"addContactsSegue"]) {
        cnfParticipantsController *participantsController = [segue destinationViewController];
//        participantsController.participantsArray = _participantsArray;
//        participantsController.parent = self;
    }
    else if ([[segue identifier] isEqualToString:@"scheduleCallSegue"]) {
//        cnfScheduleCallController *scheduleCallController = [segue destinationViewController];
//        scheduleCallController.callTime = _callTime;
//        scheduleCallController.parent = self;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    callSetupTable = nil;
    [self setCallSetupTable:nil];
    doneButton = nil;
    [self setDoneButton:nil];
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
