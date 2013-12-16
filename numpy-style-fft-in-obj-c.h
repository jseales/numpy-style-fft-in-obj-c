//
//  numpy-style-fft-in-obj-c.h
//
//  Created by John Seales on 12/16/13.
//

#import <Foundation/Foundation.h>
#include <complex.h>
#include <Accelerate/Accelerate.h>

@interface numpy_style_fft_in_obj_c : NSObject

- (DSPDoubleSplitComplex) fft: (double*)input
                   logFFTsize: (NSInteger)logFFTsize

@end
