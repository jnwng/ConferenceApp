//
//  cnfCallListController.h
//  conference2
//
//  Created by Jonathan Wong on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cnfCallListController : UIViewController 
    <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *callListTable;
    NSMutableArray *callArray;
}

@property (strong, nonatomic) IBOutlet UITableView *callListTable;
@property (strong, nonatomic) NSMutableArray *callArray;

- (void) saveCall;
- (void) loadCalls;
@end
