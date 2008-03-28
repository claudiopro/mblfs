//
//  MBLHWIconCache.m
//  MBLFS
//
//  Created by delphine on 28-03-2008.
//  Copyright 2008 Claudio Procida - Emeraldion Lodge. All rights reserved.
//

#import "MBLHWIconCache.h"


@implementation MBLHWIconCache

- (id)init
{
	if (self = [super init])
	{
		_machineTranslation = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HardwareImages"
																										  ofType:@"plist"]] retain];
	}
	return self;
}

- (void)dealloc
{
	[_iconCache release];
	[_machineTranslation release];
	[super dealloc];
}

+ (MBLHWIconCache *)sharedCache
{
	static MBLHWIconCache *_sharedCache = nil;
	
	if (!_sharedCache)
	{
		_sharedCache = [[MBLHWIconCache alloc] init];
	}
	return _sharedCache;
}

- (NSData *)iconDataForName:(NSString *)name
{
	if (_iconCache == nil)
	{
		_iconCache = [[NSMutableDictionary alloc] init];
	}
	if ([_iconCache objectForKey:name] == nil)
	{
		[_iconCache setObject:[[self iconForName:name] icnsDataWithWidth:256]
					   forKey:name];
	}
	return [_iconCache objectForKey:name];
}

- (NSImage *)iconForName:(NSString *)name
{
	return [NSImage imageNamed:[_machineTranslation objectForKey:name]];
}


@end
