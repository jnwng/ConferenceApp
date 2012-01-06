//
//  cnfDataViewController.h
//  conference2
//
//  Created by Jonathan Wong on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cnfParticipantsController.h"

@interface cnfAddNewContactController : UIViewController 
    <UITableViewDelegate, UITableViewDataSource> {
    UITextField *nameField;
    UITextField *phoneField;
    UITableView *contactSetupTable;
    UILabel *status;
    IBOutlet UIBarButtonItem *cancelButton;
    IBOutlet UIBarButtonItem *saveButton;
    cnfParticipantsController *parent;
}

@property (strong, nonatomic) UITextField *nameField;
@property (strong, nonatomic) UITextField *phoneField;
@property (strong, nonatomic) cnfParticipantsController *parent;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UITableView *contactSetupTable;

- (IBAction) onSaveButtonClick;
- (IBAction) onCancelButtonClick;

@end
