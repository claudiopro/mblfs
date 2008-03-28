//
//  MBLFS.h
//  MBLFS
//
//  Created by delphine on 17-03-2008.
//  Copyright 2008 Claudio Procida - Emeraldion Lodge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MBLHWIconCache.h"

/*!
 @class MBLFS
 @abstract Represents a MBLFS filesystem.
 @discussion MBLFS is a MacFUSE based filesystem that shows entries from the
 Shared Battery Data Archive (http://burgos.emeraldion.it/mbl/) as files in
 the Mac OS Finder.

 Every file is mapped 1:1 to an entry in the online database of battery data
 collected from Mac laptops running MiniBatteryLogger or MiniBatteryStatus Widget.

 For more information visit http://www.emeraldion.it
 */
@interface MBLFS : NSObject {
	NSDictionary* _batteries;
	MBLHWIconCache *_hwIconCache;
}

/*!
 @method initWithBatteries:
 @abstract Initializes the receiver by feeding <tt>batts</tt> to the backing store.
 @param batts A dictionary of batteries to feed to the backing store.
 @result This method returns the receiver.
 */
- (id)initWithBatteries:(NSDictionary *)batts;

@end

/*!
 @category MBLUtils
 @abstract Utilities for filesystem traversal, node retrieval etc.
 */
@interface MBLFS (MBLUtils)

/*!
 @method nodeAtPath:
 @abstract Returns an XML node at the requested path.
 @param path The path we are interested in.
 @result An XML node at the requested path.
 */
- (NSXMLNode *)nodeAtPath:(NSString *)path;

/*!
 @method stringFromQuery:atPath:
 @abstract Returns a string property by performing an XPath query for a given path.
 @param query The Xpath query.
 @param path The path we are interested in.
 @result The string resulting from the XPath query for the given path.
 */
- (NSString *)stringFromQuery:(NSString *)query atPath:(NSString *)path;

/*!
 @method iconDataForName:
 @abstract Returns named image contents as <tt>NSData</tt>.
 @param name The name of the image to return.
 @result The contents of the image as <tt>NSData</tt>.
 */
- (NSData *)iconDataForName:(NSString *)name;

@end
