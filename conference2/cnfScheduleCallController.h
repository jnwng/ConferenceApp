//
//  cnfScheduleCallController.h
//  conference
//
//  Created by Jonathan Wong on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cnfCallSetupController.h"

@interface cnfScheduleCallController : UIViewController <UIPickerViewDelegate> {
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *weekdayLabel;
    IBOutlet UIBarButtonItem *doneButton;
    
    cnfCallSetupController *parent;
    NSDate *callTime;
}

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *weekdayLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) cnfCallSetupController *parent;
@property (strong, nonatomic) NSDate *callTime;

- (IBAction)onDateChange:(id)sender;
- (IBAction)onDoneButtonClick:(id)sender;

@end
