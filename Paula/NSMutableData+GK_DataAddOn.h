//
//  NSMutableData+GK_DataAddOn.h
//  Paula
//
//  Created by Kevin Tseng on 11/24/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (GK_DataAddOn)

- (int)rw_int32AtOffset:(size_t)offset;
- (short)rw_int16AtOffset:(size_t)offset;
- (char)rw_int8AtOffset:(size_t)offset;
- (NSString *)rw_stringAtOffset:(size_t)offset bytesRead:(size_t *)amount;

@end

@interface NSMutableData (GK_DataAddOn)

- (void)rw_appendInt32:(int)value;
- (void)rw_appendInt16:(short)value;
- (void)rw_appendInt8:(char)value;
- (void)rw_appendString:(NSString *)string;

@end
