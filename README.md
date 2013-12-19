This is a method in objective-c that computes an fft, and outputs in the style of numpy and matlab. This is specifically for a real-valued input, which is cleverly (and confusingly) implemented in the Accelerate framework to save memory.

In Accelerate, you have to pack the real valued input into a complex array of half the original length. Values at even numbered indices are stored in the real parts, and values at odd indices are stored in the imaginary parts. At that point you have a structure that's represented as a complex array, even though it's just a packed up version of your real array. You do the packing with the call: vDSP_ctozD((DSPDoubleComplex *)input, 2, &fft_data, 1, nOver2);

Then you call the fft function which is specifically designed to work with the packed up real array: vDSP_fft_zripD (fftSetup, &fft_data, 1, logFFTsize, kFFTDirection_Forward); The little 'r' somewhere in the middle of the function name is what designates it as the special fft designed to work with the packed up array. "vDSP_fft_zipD" with no 'r' is the complex version, and is easier to use because there are no packing and unpacking steps, but more memory-intensive. 

The output of vDSP_fft_zripD is packed up a different way. Accelerate takes advantage of the fact that an fft with a real-valued input will always has an output with no imaginary component at two specific indices: the first, and the middle (aka nyquist) indices. So, they're packed together in the first element of the output, with the real part of the nyquist-indexed value packed into the imaginary part of the first element. 

Again, you can avoid the packing and unpacking if you use the complex valued function "vDSP_fft_zipD," but you should probably not do that unless your input is actually complex valued.

Thanks to Stack Overflow user Paul R (http://stackoverflow.com/users/253056/paul-r) good clear code that gave me a concrete grasp of what was going on in the apple documentation at https://developer.apple.com/library/ios/documentation/Performance/Conceptual/vDSP_Programming_Guide/UsingFourierTransforms/UsingFourierTransforms.html. 

The thread containing Paul R's comment can be viewed at: http://stackoverflow.com/questions/10820488/iphone-accelerate-framework-fft-vs-matlab-fft/10823152#10823152



