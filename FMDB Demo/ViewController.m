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
	
	database = [FMDatabase databaseWithPath:@"/Users/Avikant/Documents/Other/Database/univ.db"];
	if (![database open]) {
		NSLog(@"Database opening error...");
	}
	
	results = [NSMutableArray new];
	columnNames = [NSMutableArray new];
	
}

- (IBAction)textFieldDidReturn:(id)sender {
	
	if (self.textField.stringValue.length > 0) {
		[self fetchData];
	}
	
}


- (void)fetchData {
	
	for (NSString *cname in columnNames) {
		[self.tableView removeTableColumn:[self.tableView tableColumnWithIdentifier:cname]];
	}
	
	columnNames = [NSMutableArray new];
	results = [NSMutableArray new];
	
	FMResultSet *fmrset = [database executeQuery:self.textField.stringValue];
	
	for (int i = 0; i < [fmrset columnCount]; ++i) {
		NSString *cname = [fmrset columnNameForIndex:i];
		[columnNames addObject:cname];
		NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:cname];
		tableColumn.title = cname;
		[self.tableView addTableColumn:tableColumn];
	}
	
	while ([fmrset next]) {
		NSMutableDictionary *dict = [NSMutableDictionary new];
		for (NSString *cname in columnNames)
			[dict setObject:[fmrset objectForColumnName:cname] forKey:cname];
		[results addObject:dict];
	}
	
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return results.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	
	NSString *colName = [tableColumn title];
	
	if ([colName isEqualToString:@"XSNO"]) {
		return [NSString stringWithFormat:@"%li", row];
	}
	
	NSDictionary *dict = [results objectAtIndex:row];
	
	return [dict valueForKey:colName];
}

@end
