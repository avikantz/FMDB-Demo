//
//  CommandsViewController.h
//  FMDB Demo
//
//  Created by Avikant Saini on 2/21/16.
//  Copyright © 2016 avikantz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CommandSelectionDelegate <NSObject>

- (void)didSelectCommand:(NSString *)command;

@end

@interface CommandsViewController : NSViewController

@property (weak) IBOutlet NSTableView *tableView;

@property (weak, nonatomic) id<CommandSelectionDelegate> delegate;

@end
