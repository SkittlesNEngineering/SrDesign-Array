function example_signal_gen()

% Our samples must be generated at the samplerate we plan to run the device at
SAMPLE_RATE = 2e6;

% Generate 10 seconds worth of samples. Bear in mind that when using the 
% binary SC16 Q11 format, 1 sample consumes 4 bytes of memory/disk space.  
% This quickly adds up - 10 seconds @ 2 Msps yields ~ 76.3 MiB. Be careful
% when using higher sample rates!
NUM_SECONDS = 2;
NUM_SAMPLES = NUM_SECONDS * SAMPLE_RATE;

% 1.25 MHz, in radians (ω = F_Hz * 2pi)
SIGNAL_FREQ_RAD = 1.25e6 * 2 * pi;

% Generate a vector "t" which represents time, in units of samples.
% This starts at t=0, and creates NUM_SAMPLES samples in steps of 1/SAMPLE_RATE
t = [ 0 : (1/SAMPLE_RATE) : (NUM_SECONDS - 1/SAMPLE_RATE) ];

% Create a sinusoid (signal = e^(jωt) ) with a magnitude of 0.90
signal = 0.90 * exp(1j * SIGNAL_FREQ_RAD * t);

% Plot the FFT of our signal as a quick sanity check.
% The NUM_SAMPLES denominator is just to normalize this for display purposes.
f = linspace(-0.5 * SAMPLE_RATE, 0.5 * SAMPLE_RATE, length(signal));
plot(f, 20*log10(abs(fftshift(fft(signal)))/NUM_SAMPLES));
xlabel('Frequency (Hz)');
ylabel('Power (dB)');
title('1.25 MHz tone');

% Save the signal to a file
save_sc16q11('bin_signal.sc16q11', signal); 

end
