//
//  cnfCallListController.h
//  conference2
//
//  Created by Jonathan Wong on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface cnfCallListController : UIViewController 
    <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>
{
    IBOutlet UITableView *callListTable;
    NSMutableArray *callArray;
    NSManagedObject *selectedCall;
}

@property (strong, nonatomic) IBOutlet UITableView *callListTable;
@property (strong, nonatomic) NSMutableArray *callArray;
@property (strong, nonatomic) NSManagedObject *selectedCall;

- (void) loadCalls;
- (void) scheduleCall:(id)sender 
            withTitle:(NSString *)title withTime:(NSDate *)time withParticipants:(NSArray *)participants;
- (void) updateCall:(id)sender
          withTitle:(NSString *)title withTime:(NSDate *)time withParticipants:(NSArray *)participants withOriginalCall: (NSManagedObject *)call;
- (void) deleteCall: (NSManagedObject *)call;
- (void) updateCallList;
- (int) callAPI:(id)sender withTime:(NSDate *)time withParticipants:(NSArray *)participants isUpdating:(BOOL)updating;
@end
