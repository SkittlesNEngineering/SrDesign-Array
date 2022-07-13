function complex_signal_generator()
% ORDER OF OPERATIONS: 
%   1. Open this file and press run to create or update the .csv file
%   2. WAIT FOR THE FILE TO GENERATE - ITS BIG AND TAKES SOME TIME!!!

% function to generate a compmlex sine signal

% importnat note: Number   of   samples   per  buffer  to  use  in  the
%   asynchronous stream.  Must be divisible by  1024 and >= 1024

% clear; clc;

% Our samples must be generated at the samplerate we plan to run the device at
fs = 30e6;

% Generate 10 seconds worth of samples. Bear in mind that when using the 
% binary SC16 Q11 format, 1 sample consumes 4 bytes of memory/disk space.  
% This quickly adds up - 10 seconds @ 2 Msps yields ~ 76.3 MiB. Be careful
% when using higher sample rates!
seconds = 160e-6;
% n = number of samples, fs = sample rate
n = seconds * fs;

% 1.25 MHz, in radians (ω = F_Hz * 2pi)
f_rad = 1.25e6 * 2 * pi;

% Generate a vector "t" which represents time, in units of samples.
% This starts at t=0, and creates n samples in steps of 1/SAMPLE_RATE
t = [ 0 : (1/fs) : (seconds - 1/fs) ];

% Create a sinusoid (signal = e^(jωt) ) with a magnitude of 0.90
signal = 0.90 * exp(1j * f_rad * t);

% Plot the FFT of our signal as a quick sanity check.
% The NUM_SAMPLES denominator is just to normalize this for display purposes.
f = linspace(-0.5 * fs, 0.5 * fs, length(signal));
plot(f, 20*log10(abs(fftshift(fft(signal)))/n));
xlabel('Frequency (Hz)');
ylabel('Power (dB)');
title('1.25 MHz tone');

% Save the signal to a file
save_sc16q11('bin_signal.sc16q11', signal); 

end