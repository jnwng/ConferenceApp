//
//  cnfParticipantsController.h
//  conference2
//
//  Created by Jonathan Wong on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "cnfCallSetupController.h"

@interface cnfParticipantsController : UIViewController
    <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,
    ABPeoplePickerNavigationControllerDelegate>
{
    IBOutlet UITableView *participantsTable;
    IBOutlet UIToolbar *addContactButton;
    cnfCallSetupController *parent;
    NSMutableArray *recentContactsArray;
    NSMutableArray *participantsArray;
    IBOutlet UIBarButtonItem *doneButton;
}

@property (strong, nonatomic) IBOutlet UITableView *participantsTable;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addContactsButton;
@property (strong, nonatomic) NSMutableArray *recentContactsArray;
@property (strong, nonatomic) NSMutableArray *participantsArray;
@property (strong, nonatomic) cnfCallSetupController *parent;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction) onAddContactClick;
- (IBAction) onSaveButtonClick;
- (void) showExistingContacts;
- (void) showNewContact;
- (NSManagedObject *) saveRecentContact:id withName:(NSString *)name withPhoneNumber:(NSString *)phoneNumber;
- (BOOL) addContact:id withName:(NSString *)name withPhoneNumber:(NSString *)phoneNumber;
- (void) loadRecentContacts;
- (void) saveCallParticipants;
- (BOOL) checkDuplicateContact:id withPhoneNumber:(NSString *)phoneNumber;
- (NSString *) stripAndValidatePhoneNumber:(NSString *) phoneNumber;

@end
