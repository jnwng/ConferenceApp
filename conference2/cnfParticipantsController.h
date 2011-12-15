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

@interface cnfParticipantsController : UIViewController
    <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,
    ABPeoplePickerNavigationControllerDelegate>
{
    IBOutlet UINavigationBar *navBar;
    IBOutlet UITableView *participantsTable;
    IBOutlet UIToolbar *addContactButton;
    
    NSMutableArray *recentContactsArray;
}
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UITableView *participantsTable;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addContactsButton;
@property (strong, nonatomic) NSMutableArray *recentContactsArray;

- (IBAction) onAddContactClick;
- (void) showExistingContacts;
- (void) showNewContact;
- (NSManagedObject *) saveRecentContact:id withName:(NSString *)name withPhoneNumber:(NSString *)phoneNumber;
- (void) addContact:id withName:(NSString *)name withPhoneNumber:(NSString *)phoneNumber;
- (void) loadRecentContacts;
- (BOOL) checkDuplicateContact:id withPhoneNumber:(NSString *)phoneNumber;

@end
