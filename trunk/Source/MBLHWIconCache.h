//
//  MBLHWIconCache.h
//  MBLFS
//
//  Created by delphine on 28-03-2008.
//  Copyright 2008 Claudio Procida - Emeraldion Lodge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSImage+IconData.h"

/*!
 @class MBLHWIconCache
 @abstract Cache class for HW image data.
 */
@interface MBLHWIconCache : NSObject {
	NSDictionary *_machineTranslation;
	NSMutableDictionary *_iconCache;
}

/*!
 @method sharedCache
 @abstract Returns a shared <tt>MBLHWIconCache</tt> singleton object.
 */
+ (MBLHWIconCache *)sharedCache;

/*!
 @method iconDataForName:(NSString *)name
 @abstract Returns the contents of the image named <tt>name</tt> as <tt>NSData</tt>.
 @param name The name of the image requested.
 @result The contents of the image named <tt>name</tt> as <tt>NSData</tt>.
 */
- (NSData *)iconDataForName:(NSString *)name;

/*!
 @method iconForName:(NSString *)name
 @abstract Returns the image named <tt>name</tt>.
 @param name The name of the image requested.
 @result The image named <tt>name</tt>.
 */
- (NSImage *)iconForName:(NSString *)name;

@end
