//
//  UIImageView+TODOBackgroundImage.m
//  ToDo
//
//  Created by Gemini - Alex on 02/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import "UIImageView+TODOBackgroundImage.h"

@implementation UIImageView (TODOBackgroundImage)

-(void)verticallyAdjustLayerForPercent:(CGFloat)percent {
  
  CALayer *picLayer = nil;
  for (CALayer *layer in [self.layer sublayers])
    if ([[layer name] isEqualToString:@"animLayer"]){
      picLayer = layer;
      break;
    }
  
  UIImage *image = self.image;
  
  CGSize imgSize = image.size;
  
  float yOffset = MIN(0,MAX(-(imgSize.height-self.frame.size.height)*percent, -imgSize.height+self.frame.size.height));
  
  [CATransaction begin];
  [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
  BOOL noLayer = !picLayer;
  if(!picLayer){
    picLayer = [CALayer layer];
  }
  if(noLayer){
      picLayer.contents = (id)image.CGImage;
  }
  
  picLayer.anchorPoint = CGPointMake(0.0f, 0.0f);
  picLayer.bounds      = CGRectMake(0, 0, imgSize.width, imgSize.height);
  picLayer.position    = CGPointMake(0, yOffset);
  picLayer.name = @"animLayer";
  
  if(!picLayer.superlayer)
    [self.layer addSublayer:picLayer];
  
  [CATransaction commit];
}

-(void)horizontallyAdjustLayerForPercent:(CGFloat)percent {

  CALayer *picLayer = nil;
  for (CALayer *layer in [self.layer sublayers])
    if ([[layer name] isEqualToString:@"animLayer"]){
      picLayer = layer;
      break;
    }
  
  UIImage *image = self.image;
  
  CGSize imgSize = image.size;
  
  float xOffset = MIN(0,MAX(-(imgSize.width-self.frame.size.width)*percent, -imgSize.width+self.frame.size.width));
  
//  [CATransaction begin];
//  [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//  [CATransaction setAnimationDuration:5.0];
  BOOL noLayer = !picLayer;
  if(!picLayer){
    picLayer = [CALayer layer];
  }
  if(noLayer){
    picLayer.contents = (id)image.CGImage;
  }
  [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     picLayer.anchorPoint = CGPointMake(0.0f, 0.0f);
                     picLayer.bounds      = CGRectMake(0, 0, imgSize.width, imgSize.height);
                     picLayer.position    = CGPointMake(xOffset,picLayer.position.y);
                     picLayer.name = @"animLayer";
                   }
                   completion:^(BOOL finished) {
                     
                   }
   ];

  
  if(!picLayer.superlayer)
    [self.layer addSublayer:picLayer];
  
//  [CATransaction commit];
}
@end
