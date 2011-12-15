//
//  cnfCallSetupController.h
//  conference2
//
//  Created by Jonathan Wong on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cnfCallSetupController : UIViewController 
    <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *callSetupTable;
    IBOutlet UIBarButtonItem *doneButton;
        
    NSMutableString *callTitle;
    NSDate *callTime;
    NSMutableArray *participantsArray;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (strong, nonatomic) IBOutlet UITableView *callSetupTable;

@property (strong, nonatomic) NSMutableString *callTitle;
@property (strong, nonatomic) NSDate *callTime;
@property (strong, nonatomic) NSMutableArray *participantsArray;

@end
