//
//  ViewController.h
//  FMDB Demo
//
//  Created by Avikant Saini on 2/20/16.
//  Copyright © 2016 avikantz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CommandsViewController.h"

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, CommandSelectionDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *textField;

@end

