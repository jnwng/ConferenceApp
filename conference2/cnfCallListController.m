//
//  cnfCallListController.m
//  conference2
//
//  Created by Jonathan Wong on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cnfCallListController.h"
#import "cnfAppDelegate.h"
#import "cnfCallSetupController.h"

@implementation cnfCallListController
@synthesize callListTable, callArray, selectedCall;

- (void) loadCalls {
    cnfAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = 
    [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = 
    [NSEntityDescription entityForName:@"Call" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    callArray = [[context executeFetchRequest:request error:&error] mutableCopy];
}

- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    
    [callArray removeObjectAtIndex:row];
    
    [tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    /*NSUInteger row = [indexPath row];
    NSUInteger count = [callArray count];
	
    if (row < count) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }*/
    
    return UITableViewCellEditingStyleDelete;
}

- (void) scheduleCall:(id)sender withTitle:(NSString *)title withTime:(NSDate *)time withParticipants:(NSArray *)participants {
    cnfAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newCall;
    newCall = [NSEntityDescription insertNewObjectForEntityForName:@"Call" inManagedObjectContext:context];
    [newCall setValue:title forKey:@"title"];
    [newCall setValue:time forKey:@"time"];
    NSMutableSet *callParticipants = [newCall mutableSetValueForKey:@"participants"];
    [callParticipants addObjectsFromArray:participants];
    NSError *error;
    [context save:&error];
    
    [self callAPI:self withTime:time withParticipants:participants isUpdating:NO];
    
    [callArray addObject:newCall];
    [self updateCallList];
}

- (void) updateCall:(id)sender withTitle:(NSString *)title withTime:(NSDate *)time 
   withParticipants:(NSArray *)participants withOriginalCall:(NSManagedObject *)call {
    [call setValue:title forKey:@"title"];
    [call setValue:time forKey:@"time"];
    NSMutableSet *callParticipants = [call mutableSetValueForKey:@"participants"];
    [callParticipants addObjectsFromArray:participants];
    
    cnfAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context refreshObject:call mergeChanges:YES];
    NSError *error;
    [context save:&error];
    [self updateCallList];
}

- (void) deleteCall:(NSManagedObject *)call {
//    [callArray replaceObjectAtIndex:<#(NSUInteger)#> withObject:<#(id)#>:call];
//    cnfAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    [context refreshObject:<#(NSManagedObject *)#> mergeChanges:<#(BOOL)#>:call];
//    NSError *error;
//    [context save:&error];
//    [self updateCallList];
}
 
- (void) updateCallList {
    NSIndexSet *sectionIndex = [[NSIndexSet alloc] initWithIndex:0];
    [callListTable beginUpdates];
    [callListTable reloadSections:sectionIndex withRowAnimation:YES];
    [callListTable endUpdates];
    sectionIndex = nil;
}

- (void) callAPI:(id)sender withTime:(NSDate *)time 
        withParticipants:(NSArray *)participants isUpdating:(BOOL)updating {
    
    /*if(![self connected])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"No network connection." 
                                                       delegate:nil 
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
        return nil;    
    }*/
    
    //add own phone automatically to call here?
    NSString *participantText, *tempText, *phoneText;
    NSURLConnection *urlConnection;
    NSTimeInterval unixInterval = [time timeIntervalSince1970];
    NSString *callTimeText = [[NSString alloc] initWithFormat:@"date=%0.0f", unixInterval];
    
    participantText = [[NSString alloc] initWithString:@""];
    for (int i = 0; i < [participants count]; i ++) {
        phoneText = [[participants objectAtIndex:i] valueForKey:@"phone"];
        tempText = [NSString stringWithFormat:@"%@,", phoneText];
        participantText = [participantText stringByAppendingString:tempText];
    }
    
    NSString *fullURL = [[NSString alloc] initWithString:@"http://tiktam.herokuapp.com/api/conferences/new?"];
    fullURL = [fullURL stringByAppendingString:callTimeText];
    fullURL = [fullURL stringByAppendingString:@"&numbers="];
    fullURL = [fullURL stringByAppendingString:participantText];
    NSURL *confURL = [[NSURL alloc] initWithString:fullURL];
    urlConnection = [[NSURLConnection alloc] initWithRequest: [NSURLRequest requestWithURL: confURL] delegate: self startImmediately: YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
    if ([[segue identifier] isEqualToString:@"addCallSegue"]) {
        cnfCallSetupController *callSetupController = [segue destinationViewController];
        callSetupController.parent = self;
        if (selectedCall) {
            callSetupController.callToUpdate = selectedCall;
            selectedCall = nil;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CallCell";
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    //    // Get the object to display and set the value in the cell.
    
    NSManagedObject *call = [callArray objectAtIndex:/*[callArray count] - */[indexPath row] /*- 1*/];
    cell.textLabel.text = [call valueForKey:@"title"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [callArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedCall = [callArray objectAtIndex:[indexPath row]];
    [self performSegueWithIdentifier:@"addCallSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedCall = nil;
}

/*- (BOOL)connected 
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    return !(networkStatus == NotReachable);
}*/

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    callArray = [[NSMutableArray alloc] init];
    [self loadCalls];
}


- (void)viewDidUnload
{
    callListTable = nil;
    callArray = nil;
    [self setCallListTable:nil];
    [self setCallArray:nil];
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
