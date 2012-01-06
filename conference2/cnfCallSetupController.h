//
//  cnfCallSetupController.h
//  conference2
//
//  Created by Jonathan Wong on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cnfCallListController.h"

@interface cnfCallSetupController : UIViewController 
    <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    IBOutlet UITableView *callSetupTable;
    IBOutlet UIBarButtonItem *scheduleButton;
    NSManagedObject *callToUpdate;
    NSString *callTitle;
    NSDate *callTime;
    NSMutableArray *participantsArray;
    UITextField *callTitleTextField;
    UITableViewCell *callTimeCell;
    cnfCallListController *parent;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *scheduleButton;
@property (strong, nonatomic) IBOutlet UITableView *callSetupTable;
@property (strong, nonatomic) NSManagedObject *callToUpdate;
@property (strong, nonatomic) cnfCallListController *parent;
@property (strong, nonatomic) NSString *callTitle;
@property (strong, nonatomic) NSDate *callTime;
@property (strong, nonatomic) NSMutableArray *participantsArray;
@property (strong, nonatomic) UITextField *callTitleTextField;
@property (strong, nonatomic) UITableViewCell *callTimeCell;

- (NSString *)getStringFromDate: (NSDate *)date;
- (void)updateTime: (NSDate *)date;
- (void)updateTitle: (NSString *)title;
- (void)updateParticipants;
- (IBAction)onScheduleButtonClick;

@end
