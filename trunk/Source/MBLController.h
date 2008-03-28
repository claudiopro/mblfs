//
//  MBLController.h
//  MBLFS
//
//  Created by delphine on 17-03-2008.
//  Copyright 2008 Claudio Procida - Emeraldion Lodge. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GMUserFileSystem;

@interface MBLController : NSObject {
	GMUserFileSystem* fs_;
}

@end

@interface MBLController (MBLUtils)
- (NSDictionary *)fetchBatteries;
@end

@interface MBLController (Notifications)
- (void)didMount:(NSNotification *)notification;
- (void)didUnmount:(NSNotification *)notification;
@end
