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
seconds = 160e-4;
% n = number of samples, fs = sample rate
n = seconds * fs;

% 1.25 MHz, in radians (ω = F_Hz * 2π)
f_hz = 1.25e6;
f_rad = f_hz * 2 * pi;

% Phase shift, phi or φ, in radians from degrees (φ = °/180 * π)
deg1 = 0;
phi1 = (deg1/180) * pi;
deg2 = 90;
phi2 = (deg2/180) * pi;

% Generate a vector "t" which represents time, in units of samples.
% This starts at t=0, and creates n samples in steps of 1/SAMPLE_RATE
t = 0 : (1/fs) : (seconds - 1/fs);

% Create a sinusoid (signal = e^(jωt) ) with a magnitude of 0.90
% Shift signal by specified angle (shift = e^(jφ))
signal1 = 0.90 * exp(1j * phi1) * exp(1j * f_rad * t);
signal2 = 0.90 * exp(1j * phi2) * exp(1j * f_rad * t);

% Plot the FFT of our signal as a quick sanity check.
% The NUM_SAMPLES denominator is just to normalize this for display purposes.
t_plot = 4/f_hz: 1/fs : (8/f_hz - 1/fs);
plot(t_plot, signal1(1:96));
hold on;
grid on;
plot(t_plot, signal2(1:96));
xlabel('Time (s)');
ylabel('Magnitude');

% f = linspace(-0.5 * fs, 0.5 * fs, length(signal1));
% plot(f, 20*log10(abs(fftshift(fft(signal1)))/n));
% grid on;
% hold on;
% plot(f, 20*log10(abs(fftshift(fft(signal2)))/n));
% xlabel('Frequency (Hz)');
% ylabel('Power (dB)');
% title('Signals');

% Save the signal to a file
tx1_filename = 'zero_element1.csv';
tx2_filename = 'zero_element2.csv';
combined_filename = 'leader_zero.csv';

save_csv(tx1_filename, signal1); 
save_csv(tx2_filename, signal2);

tx1_table = readtable(tx1_filename);
tx2_table = readtable(tx2_filename);
tx2_table = renamevars(tx2_table,["Var1","Var2"],["Var3","Var4"]);
combined_table = [tx1_table tx2_table];
writetable(combined_table, combined_filename, 'Delimiter',',','WriteVariableNames',0);

delete zero_element1.csv;
delete zero_element2.csv;
    

end