//
//  NSMutableData+GK_DataAddOn.m
//  Paula
//
//  Created by Kevin Tseng on 11/24/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import "NSMutableData+GK_DataAddOn.h"

@implementation NSData (GK_DataAddOn)

- (int)rw_int32AtOffset:(size_t)offset {
	const int *intBytes = (const int *)[self bytes];
	return ntohl(intBytes[offset / 4]);
}

- (short)rw_int16AtOffset:(size_t)offset {
	const short *shortBytes = (const short *)[self bytes];
	return ntohs(shortBytes[offset / 2]);
}

- (char)rw_int8AtOffset:(size_t)offset {
	const char *charBytes = (const char *)[self bytes];
	return charBytes[offset];
}

- (NSString *)rw_stringAtOffset:(size_t)offset bytesRead:(size_t *)amount {
	const char *charBytes = (const char *)[self bytes];
	NSString *string = [NSString stringWithUTF8String:charBytes + offset];
	*amount = strlen(charBytes + offset) + 1;
	return string;
}

@end

@implementation NSMutableData (GK_DataAddOn)

- (void)rw_appendInt32:(int)value {
	value = htonl(value);
	[self appendBytes:&value length:4];
}

- (void)rw_appendInt16:(short)value {
	value = htons(value);
	[self appendBytes:&value length:2];
}

- (void)rw_appendInt8:(char)value {
	[self appendBytes:&value length:1];
}

- (void)rw_appendString:(NSString *)string {
    NSMutableString *mstring = [NSMutableString stringWithString:string];
    if([string length] % 2 == 0) {
        [mstring appendString:@" "];
    }
	const char *cString = [mstring UTF8String];
	[self appendBytes:cString length:strlen(cString) + 1];
}

@end
