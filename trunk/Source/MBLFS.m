//
//  MBLFS.m
//  MBLFS
//
//  Created by delphine on 17-03-2008.
//  Copyright 2008 Claudio Procida - Emeraldion Lodge. All rights reserved.
//

#import "MBLFS.h"
#import "NSImage+IconData.h"


@implementation MBLFS

static NSString* const kThumbURLQuery = @"./mbla:machine"; 
static NSString* const kLastUpdatedDateQuery = @"./@lastUpdated"; 

#pragma mark GMUserFileSystem Delegate Operations

#pragma mark INSERT CODE HERE

- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path 
                                 error:(NSError **)error {
	return [_batteries allKeys];
}

- (NSData *)iconDataAtPath:(NSString *)path {
	NSString *name = [self stringFromQuery:kThumbURLQuery atPath:path];
	NSLog(@"%@", name);
	if (name) {
		return [self iconDataForName:name];
	}
	return nil;
}

- (NSDictionary *)attributesOfItemAtPath:(NSString *)path 
                                   error:(NSError **)error {
	if ([self nodeAtPath:path]) {
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSCalendarDate dateWithString:[self stringFromQuery:kLastUpdatedDateQuery
																													  atPath:path]
																						calendarFormat:@"%Y-%m-%d %H:%M:%S"],
			NSFileModificationDate,
			nil];
		return dict;
	}
	return nil;
}

- (NSData *)contentsAtPath:(NSString *)path {
	NSXMLNode* node = [self nodeAtPath:path];
	if (node) {
		NSString* xml = [node XMLStringWithOptions:NSXMLNodePrettyPrint];
		return [xml dataUsingEncoding:NSUTF8StringEncoding];
	}
	return nil;
}

- (UInt16)finderFlagsAtPath:(NSString *)path {
	return ([self nodeAtPath:path] ? kHasCustomIcon : 0);
}

#pragma mark -

#pragma mark Init and Dealloc

- (id)init { return [self initWithBatteries:nil]; }

- (id)initWithBatteries:(NSDictionary *)batteries {
	if ((self = [super init])) {
		_hwIconCache = [MBLHWIconCache sharedCache];
		_batteries = [batteries retain];
	}
	return self;
}
- (void)dealloc {
	[_batteries release];
	[_hwIconCache release];
	[super dealloc];
}

@end

@implementation MBLFS (MBLUtils)

- (NSXMLNode *)nodeAtPath:(NSString *)path {
	NSArray* components = [path pathComponents];
	if ([components count] != 2) {
		return nil;
	}
	NSXMLNode* node = [_batteries objectForKey:[components objectAtIndex:1]];
	return node;
}

- (NSString *)stringFromQuery:(NSString *)query atPath:(NSString *)path {
	NSXMLNode* node = [self nodeAtPath:path];
	if (node != nil) {
		NSError* error = nil;
		NSArray* nodes = [node nodesForXPath:query error:&error];
		if (nodes != nil && [nodes count] > 0) {
			return [[nodes lastObject] stringValue];
		}
	}
	return nil;
}

- (NSData *)iconDataForName:(NSString *)name
{
	return [_hwIconCache iconDataForName:name];
}

@end
