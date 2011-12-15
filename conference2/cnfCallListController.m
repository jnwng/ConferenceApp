//
//  cnfCallListController.m
//  conference2
//
//  Created by Jonathan Wong on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cnfCallListController.h"
#import "cnfAppDelegate.h"

@implementation cnfCallListController
@synthesize callListTable, callArray;

- (void)saveCall {
    cnfAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newCall;
    newCall = [NSEntityDescription insertNewObjectForEntityForName:@"Calls" inManagedObjectContext:context];
    [newCall setValue:@"TestTime" forKey:@"time"];
    [newCall setValue:@"TestTitle" forKey:@"title"];
//    name.text = @"";
//    phone.text = @"";
    NSError *error;
    [context save:&error];
//    status.text = @"Contact Saved";
}

- (void) loadCalls {
    cnfAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = 
    [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = 
    [NSEntityDescription entityForName:@"Calls" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@""];
    [request setPredicate:pred];
//    NSManagedObject *matches = nil;
    NSError *error;
    callArray = [[context executeFetchRequest:request error:&error] mutableCopy];
    if ([callArray count] == 0) {
//        status.text = @"No matches";
    } 
//    else {
//            [callArray addObject:matches];
////        matches = [objects objectAtIndex:0];
////        address.text = [matches valueForKey:@"address"];
////        phone.text = [matches valueForKey:@"phone"];
////        status.text = [NSString stringWithFormat:
////                       @"%d matches found", [objects count]];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CallCell";
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    //    // Get the object to display and set the value in the cell.
    NSManagedObject *call = [callArray objectAtIndex:[indexPath row]];
    cell.textLabel.text = [call valueForKey:@"title"];
//    cell.timeLabel.text = [call valueForKey:@"time"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
