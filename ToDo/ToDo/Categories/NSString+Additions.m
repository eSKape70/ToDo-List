//
//  NSString+Additions.m
//  ToDo
//
//  Created by Gemini - Alex on 04/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSString *)URLEncodedString {
  NSMutableString * output = [NSMutableString string];
  const unsigned char * source = (const unsigned char *)[self UTF8String];
  unsigned long sourceLen = strlen((const char *)source);
  for (int i = 0; i < sourceLen; ++i) {
    const unsigned char thisChar = source[i];
    if (thisChar == ' '){
      [output appendString:@"+"];
    } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
               (thisChar >= 'a' && thisChar <= 'z') ||
               (thisChar >= 'A' && thisChar <= 'Z') ||
               (thisChar >= '0' && thisChar <= '9')) {
      [output appendFormat:@"%c", thisChar];
    } else {
      [output appendFormat:@"%%%02X", thisChar];
    }
  }
  return [output stringByReplacingOccurrencesOfString:@"~" withString:@"%7E"];
}


@end
