//
//  CommandsViewController.m
//  FMDB Demo
//
//  Created by Avikant Saini on 2/21/16.
//  Copyright © 2016 avikantz. All rights reserved.
//

#import "CommandsViewController.h"

@interface CommandsViewController () <NSTableViewDataSource, NSTableViewDelegate>

@end

@implementation CommandsViewController {
	NSMutableArray *commands;
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
    // Do view setup here.
	
	commands = [[NSUserDefaults standardUserDefaults] objectForKey:@"commands"];
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	
	return commands.count;
	
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	
	return [commands objectAtIndex:row];
}

#pragma mark - Table view delegate

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
	
	if ([self.delegate respondsToSelector:@selector(didSelectCommand:)])
		[self.delegate didSelectCommand:[commands objectAtIndex:row]];
	
	return YES;
}


@end
