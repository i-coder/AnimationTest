//
//  EAAnimAgent.m
//  Test
//
//  Created by Андрей Ежов on 15.11.14.
//  Copyright (c) 2014 Ezhov Andrey. All rights reserved.
//

#import "EAAnimAgent.h"
@interface EAAnimAgent()

@property (strong, nonatomic) NSArray* namesArray; //упорядоченные имена кадров

@end


@implementation EAAnimAgent

- (void) getAnimation:(NSDictionary*) dictionary {
    
    [self getAllKeysFromDict:dictionary];
    
    self.animationImages = [self getImagesArray:dictionary];
    self.animationDuration = 4.f;
    
    [self startAnimating];
}


- (void) getAllKeysFromDict:(NSDictionary*) dictionary {
    
    self.namesArray = [[[dictionary valueForKey:@"frames"] allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
}


- (NSArray*) getImagesArray:(NSDictionary*) dictionary {
    
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];

    //получение карты анимации для конктретного случая
    UIImage *Image = [UIImage imageNamed:[[dictionary valueForKey:@"metadata"] valueForKey:@"textureFileName"]];
    
    
    for (NSString* string in self.namesArray) {
        
        //получение координат кардров на карте и занесение в массив
        NSString* text =[[[dictionary valueForKey:@"frames"] valueForKey:string] valueForKey:@"frame"];

        NSArray* coordArray = [self arrayWithCoordinates:text];
        
        if (coordArray) {
        
            UIImage* tmpImage;
            CGRect rect;
            CGImageRef cropImage;

            if ([[[[dictionary valueForKey:@"frames"] valueForKey:string] valueForKey:@"rotated"]intValue]) {
            
                rect = CGRectMake([[coordArray objectAtIndex:0] intValue],
                                  [[coordArray objectAtIndex:1] intValue],
                                  [[coordArray objectAtIndex:3] intValue],
                                  [[coordArray objectAtIndex:2] intValue]);
            
                cropImage= CGImageCreateWithImageInRect([Image CGImage],rect);
                tmpImage = [UIImage imageWithCGImage:cropImage];
            
                //работа с контекстом, для разворота кадра
                CGFloat w = CGImageGetWidth (cropImage), h = CGImageGetHeight (cropImage);
                UIGraphicsBeginImageContext (CGSizeMake (h, w));
                CGContextRef context = UIGraphicsGetCurrentContext ();
                CGContextConcatCTM (context, CGAffineTransformMake (0.0, -1.0, -1.0, 0.0, h, w));
                CGContextDrawImage (context, CGRectMake (0, 0, w, h), cropImage);
                tmpImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();

            } else {
            
                rect = CGRectMake([[coordArray objectAtIndex:0] intValue],
                                  [[coordArray objectAtIndex:1] intValue],
                                  [[coordArray objectAtIndex:2] intValue],
                                  [[coordArray objectAtIndex:3] intValue]);
            
                cropImage= CGImageCreateWithImageInRect([Image CGImage],rect);
                tmpImage = [UIImage imageWithCGImage:cropImage];

            }

            [resultArray addObject:tmpImage];
            
        } else {
            
            NSLog(@"Wrong coordinats for frame %@", string);
            
        }

    }
    
    return (NSArray*)resultArray;
}


- (NSArray*) arrayWithCoordinates:(NSString*) text {
    
    //вычисление координат кадра
    NSRegularExpression *nameExpression = [NSRegularExpression regularExpressionWithPattern:@"([0-9]{1,4})"
                                                                                    options:0
                                                                                      error:nil];
    NSArray *tmp = [nameExpression matchesInString:text
                                           options:0
                                             range:NSMakeRange(0, [text length])];
    
    NSMutableArray* result = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in tmp) {
        NSRange matchRange = [match rangeAtIndex:0];
        NSString *matchString = [text substringWithRange:matchRange];
        [result addObject:matchString];
    }
    
    if ([result count] != 4) {
        result = nil;
    }
    
    return (NSArray*)result;
}


@end
