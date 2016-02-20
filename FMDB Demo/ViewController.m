//
//  ViewController.m
//  FMDB Demo
//
//  Created by Avikant Saini on 2/20/16.
//  Copyright © 2016 avikantz. All rights reserved.
//

#import "ViewController.h"
#import <FMDB/FMDB.h>

@implementation ViewController {
	FMDatabase *database;
	
	NSMutableArray *results;
	NSMutableArray *columnNames;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	// Do any additional setup after loading the view.
	
	// Initialize the database
	
	database = [FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:@"univ.db" ofType:nil]];
	
	// Open the database
	
	if (![database open]) {
		[[NSAlert alertWithError:[NSError errorWithDomain:@"Database opening error" code:404 userInfo:nil]] runModal];
	}
	
	// Get the last query
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastQuery"]) {
		self.textField.stringValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastQuery"];
	}
	
	results = [NSMutableArray new];
	columnNames = [NSMutableArray new];
	
	[self.tableView reloadData];
	
}

- (IBAction)textFieldDidReturn:(id)sender {
	
	if (self.textField.stringValue.length > 0) {
		[[NSUserDefaults standardUserDefaults] setObject:self.textField.stringValue forKey:@"lastQuery"];
		[self fetchData];
	}
	
}

- (void)fetchData {
	
	// Remove table columns of previously added
	for (NSString *cname in columnNames) {
		[self.tableView removeTableColumn:[self.tableView tableColumnWithIdentifier:cname]];
	}
	
	// reinit column names
	
	columnNames = [NSMutableArray new];
	results = [NSMutableArray new];
	
	
	// Execute query
	
	NSError *error;
	FMResultSet *fmrset = [database executeQuery:self.textField.stringValue values:nil error:&error];
	
	// Raw error handling
	
	if (error) {
		[[NSAlert alertWithError:error] runModal];
		return;
	}
	
	// Add columns to the table view
	
	for (int i = 0; i < [fmrset columnCount]; ++i) {
		
		NSString *cname = [fmrset columnNameForIndex:i];
		
		[columnNames addObject:cname];
		
		NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:cname];
		tableColumn.title = cname;
		
		[self.tableView addTableColumn:tableColumn];
		
	}
	
	// While next row is found, add it to the array with all values
	
	while ([fmrset next]) {
		
		NSMutableDictionary *dict = [NSMutableDictionary new];
		
		for (NSString *cname in columnNames)
			[dict setObject:[fmrset objectForColumnName:cname] forKey:cname];
		
		[results addObject:dict];
		
	}
	
	self.view.window.title = [NSString stringWithFormat:@"%li rows selected.", results.count];
	
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	
	return results.count;
	
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	
	NSString *colName = [tableColumn title];
	
	if ([colName isEqualToString:@"XSNO"]) {
		return [NSString stringWithFormat:@"%li", row + 1];
	}
	
	NSDictionary *dict = [results objectAtIndex:row];
	
	return [dict valueForKey:colName];
}

#pragma mark - Table view delegate

- (BOOL)tableView:(NSTableView *)tableView shouldSelectTableColumn:(NSTableColumn *)tableColumn {
	return NO;
}

@end
