//
//  MBLController.m
//  MBLFS
//
//  Created by delphine on 17-03-2008.
//  Copyright 2008 Claudio Procida - Emeraldion Lodge. All rights reserved.
//

#import "MBLController.h"
#import "MBLFS.h"
#import <MacFUSE/GMUserFileSystem.h>


@implementation MBLController

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	// Pump up our url cache.
	NSURLCache* cache = [NSURLCache sharedURLCache];
	[cache setDiskCapacity:(1024 * 1024 * 500)];
	[cache setMemoryCapacity:(1024 * 1024 * 40)];
	
#pragma mark INSERT CODE HERE
	NSMutableArray* options = [NSMutableArray array];
	[options addObject:@"ro"];
	[options addObject:@"volname=MBLFS"];
	[options addObject:
		[NSString stringWithFormat:@"volicon=%@", 
			[[NSBundle mainBundle] pathForResource:@"mblfs" ofType:@"icns"]]];
	
	MBLFS* mblfs = [[MBLFS alloc] initWithBatteries:[self fetchBatteries]];
	
	fs_ = [[GMUserFileSystem alloc] initWithDelegate:mblfs isThreadSafe:YES];
	[fs_ mountAtPath:@"/Volumes/mblfs" withOptions:options];
	
	NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(didMount:)
				   name:kGMUserFileSystemDidMount object:nil];
	[center addObserver:self selector:@selector(didUnmount:)
				   name:kGMUserFileSystemDidUnmount object:nil];
#pragma mark -
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
#pragma mark INSERT MORE CODE HERE
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[fs_ unmount];
	id delegate = [fs_ delegate];
	[fs_ release];
	[delegate release];
#pragma mark -
	return NSTerminateNow;
}

@end

@implementation MBLController (Notifications) 

- (void)didMount:(NSNotification *)notification {
	NSDictionary* userInfo = [notification userInfo];
	NSString* mountPath = [userInfo objectForKey:@"mountPath"];
	NSString* parentPath = [mountPath stringByDeletingLastPathComponent];
	[[NSWorkspace sharedWorkspace] selectFile:mountPath
					 inFileViewerRootedAtPath:parentPath];
}

- (void)didUnmount:(NSNotification*)notification {
	[[NSApplication sharedApplication] terminate:nil];
}

@end

@implementation MBLController (MBLUtils)

static NSString* const kFeedURL = @"http://burgos.emeraldion.it/mbl/api/list/MacBookAir1,1";

- (NSDictionary *)fetchBatteries {
	NSURL* url = [NSURL URLWithString:kFeedURL];
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	NSURLResponse* response = nil;
	NSError* error = nil;
	NSData* data = [NSURLConnection sendSynchronousRequest:request 
										 returningResponse:&response
													 error:&error];
	if (data == nil) {
		NSRunAlertPanel(@"MBLFS Error", @"Unable to download feed.",
						@"Quit", nil, nil);
		exit(1);
	}
	NSXMLDocument* doc = [[NSXMLDocument alloc] initWithData:data 
													 options:0 
													   error:&error];
	NSLog(@"%@", doc);
	NSArray* xmlEntries = [[doc rootElement] nodesForXPath:@"./channel/item/mbla:entry" 
													 error:&error];
	if ([xmlEntries count] == 0) {
		NSRunAlertPanel(@"MBLFS Error", @"Feed has zero entries.  Bummer.",
						@"Quit", nil, nil);
		exit(1);
	}
	
	NSMutableDictionary* batts = [NSMutableDictionary dictionary];
	int i;
	for (i = 0; i < MIN([xmlEntries count], 10); ++i) {
		NSXMLNode* node = [xmlEntries objectAtIndex:i];
		NSArray* nodes = [node nodesForXPath:@"./@hash" error:&error];
		NSString* title = [[nodes objectAtIndex:0] stringValue];
		NSMutableString* name = [NSMutableString stringWithFormat:@"%@.battery", title];
		[name replaceOccurrencesOfString:@"/"
							  withString:@":"
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [name length])];
		[batts setObject:node forKey:name];
	}
	return batts;
}

@end
