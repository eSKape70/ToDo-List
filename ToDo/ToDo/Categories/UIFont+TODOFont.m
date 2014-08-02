//
//  UIFont+TODOFont.m
//  ToDo
//
//  Created by Gemini - Alex on 02/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import "UIFont+TODOFont.h"

@implementation UIFont (TODOFont)

+ (UIFont *)TODOFontWithSize: (CGFloat)fontSize {
  return [UIFont fontWithName:@"Helvetica-Neue" size:fontSize];
}
+ (UIFont *)TODOBoldFontWithSize: (CGFloat)fontSize {
  return [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
}

@end
