//
//  cnfScheduleCallController.m
//  conference
//
//  Created by Jonathan Wong on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cnfScheduleCallController.h"

@implementation cnfScheduleCallController
@synthesize dateLabel, timeLabel, weekdayLabel, doneButton, datePicker, callTime, parent;

- (IBAction)onDateChange:(id)sender {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
	df.dateStyle = NSDateFormatterMediumStyle;
	dateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
    df.dateFormat = @"h:mm a";
    timeLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
    df.dateFormat = @"EEEE";
    weekdayLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
    
    callTime = datePicker.date;
    df = nil;
}

- (IBAction)onDoneButtonClick:(id)sender {
    [parent updateTime:datePicker.date];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    if (callTime == nil) {
        callTime = [NSDate date];
    }
    [datePicker setDate:callTime];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    dateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:[datePicker date]]];
    df.dateFormat = @"h:mm a";
    timeLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:[datePicker date]]];
    df.dateFormat = @"EEEE";
    weekdayLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:[datePicker date]]];
    
    df = nil;
}

- (void)viewDidUnload {
    datePicker = nil;
    dateLabel = nil;
    timeLabel = nil;
    weekdayLabel = nil;
    [self setDatePicker:nil];
    [self setDateLabel:nil];
    [self setTimeLabel:nil];
    [self setWeekdayLabel:nil];
    doneButton = nil;
    [self setDoneButton:nil];
    [super viewDidUnload];
}

@end
