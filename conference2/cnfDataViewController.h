//
//  cnfDataViewController.h
//  conference2
//
//  Created by Jonathan Wong on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cnfDataViewController : UIViewController {
    UITextField *name;
    UITextField *phone;
    UILabel *status;
}

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UILabel *status;

- (IBAction) saveContact;

@end
