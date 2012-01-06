//
//  cnfDataViewController.m
//  conference2
//
//  Created by Jonathan Wong on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cnfAddNewContactController.h"
#import "cnfAppDelegate.h"

@implementation cnfAddNewContactController
@synthesize contactSetupTable;
@synthesize nameField, phoneField, parent, saveButton, cancelButton;

- (void) onSaveButtonClick {
    if ([parent addContact:self withName:nameField.text withPhoneNumber:phoneField.text]) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void) onCancelButtonClick {
    [self dismissModalViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CallCell"; 
    NSInteger row = [indexPath row];
    switch (row) {
        case 0:
            CellIdentifier = @"contactNameCell";
            break;
        case 1:
            CellIdentifier = @"contactPhoneCell";                
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
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
    textField.adjustsFontSizeToFitWidth = YES;
    textField.textColor = [UIColor blackColor];
    
    if ([CellIdentifier isEqualToString:@"contactNameCell"]) {
        textField.placeholder = @"John Appleseed";
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyNext;
        nameField = textField;
        [nameField becomeFirstResponder];
        cellLabel = @"Name";
    }
    else if ([CellIdentifier isEqualToString:@"contactPhoneCell"]) {
        textField.placeholder = @"##########";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        phoneField = textField;
        cellLabel = @"Phone";
    }
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
    textField.textAlignment = UITextAlignmentLeft;
    textField.tag = 0;
        
    textField.clearButtonMode = UITextFieldViewModeWhileEditing; 
    [textField setEnabled: YES];
        
    [cell addSubview:textField];
    
    cell.textLabel.text = cellLabel;
    
    textField = nil;
    cellLabel = nil;
    CellIdentifier = nil;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setCancelButton:nil];
    cancelButton = nil;
    saveButton = nil;
    [self setSaveButton:nil];
    contactSetupTable = nil;
    [self setContactSetupTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.nameField = nil;
    self.phoneField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
