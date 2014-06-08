//
//  BTCountlyArcCheck.h
//  BTCountly
//
//  Created by Thaddeus on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_feature(objc_arc)
#error BTCountly must be compiled without ARC; Include the static library in your project, or add -fno-objc-arc to the BTCountly files in your own project.
#endif