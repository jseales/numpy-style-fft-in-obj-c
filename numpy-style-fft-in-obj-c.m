//
//  numpy-style-fft-in-obj-c.m
//
//  Created by John Seales on 12/16/13.
//

#import "numpy-style-fft-in-obj-c.h"
#include <complex.h>
#include <Accelerate/Accelerate.h>

@implementation numpy_style_fft_in_obj_c

- (DSPDoubleSplitComplex) fft: (double*)input
                   logFFTsize: (NSInteger)logFFTsize {
    
    const int n = 1 << logFFTsize;
    const int nOver2 = 1 << (logFFTsize - 1);
    
    DSPDoubleSplitComplex fft_data;
    fft_data.realp = malloc(nOver2 * sizeof(double));
    fft_data.imagp = malloc(nOver2 * sizeof(double));
    
    FFTSetupD fftSetup = vDSP_create_fftsetupD (logFFTsize, kFFTRadix2);
    vDSP_ctozD((DSPDoubleComplex*)input, 2, &fft_data, 1, nOver2);
    vDSP_fft_zripD (fftSetup, &fft_data, 1, logFFTsize, kFFTDirection_Forward);
    
    for (int i = 0; i<nOver2; i++){
        fft_data.realp[i] *=0.5;
        fft_data.imagp[i] *=0.5;
    }
    
    DSPDoubleSplitComplex output;
    output.realp = malloc(n * sizeof(double));
    output.imagp = malloc(n * sizeof(double));
    
    output.realp[0] = fft_data.realp[0];
    output.imagp[0] = 0;
    output.realp[nOver2] = fft_data.imagp[0];
    output.imagp[nOver2] = 0;
    for (int i = 1; i<nOver2; i++){
        output.realp[i] = fft_data.realp[i];
        output.imagp[i] = fft_data.imagp[i];
        output.realp[n - i] = fft_data.realp[i];
        output.imagp[n - i] = fft_data.imagp[i];
    }
    
    return output;
    
}

@end
