function complex_signal_generator()
% ORDER OF OPERATIONS: 
%   1. Open this file and press run to create or update the .csv file
%   2. WAIT FOR THE FILE TO GENERATE - ITS BIG AND TAKES SOME TIME!!!

% Function to generate a complex sine signal

clear; close all; clc;
combined_filename = 'leader_zero.csv';
sig1_deg = 0;
sig2_deg = 20;

% NOTE: Number of samples per buffer to use in the asynchronous stream
%       must be divisible by 1024 and >= 1024
%       Buffer size is ???

% NOTE: when using the binary SC16 Q11 format,
% 1 sample consumes ~4 bytes of memory/disk space.  
% This quickly adds up: 10 seconds @ 2 MSps yields ~ 76.3 MiB.
% Be careful when using higher sample rates!

% Samples must be generated at samplerate we plan to run device at.
% Set signal length to a reasonable number of seconds. (Save disk space.)
% Check number of samples per buffer is multiple of 1024
% n_buffer = 16384 samples = 2^14 or 16 kS (binary)
% buffers = 32
% samples needed = n_buffer * buffers = 524288 = 512 kS (binary)

fs = 2^25;           % fs = sample rate, 33554432 or 32 MSps (binary)
seconds = 15.625e-3; % Number of seconds of signal to generate for .csv file, ~16 ms
n = seconds * fs;     % n = number of samples, 512 kS (binary)

% 1 MHz, in radians (ω = F_Hz * 2π)
f_hz = 1e6;
f_rad = f_hz * 2 * pi;

% Phase shift, phi or φ, in radians from degrees (φ = °/180 * π)
phi1 = (sig1_deg/180) * pi;
phi2 = (sig2_deg/180) * pi;

% Generate a vector "t" which represents time, in units of samples.
% This starts at t=0, and creates n samples in steps of 1/SAMPLE_RATE
t = 0 : (1/fs) : (seconds - 1/fs);

% Create a sinusoid (signal = e^(jωt) ) with a magnitude of 0.90
    % Eulers equation:         e^(jωt) = cos(ωt) + jsin(ωt)
% Shift signal by specified angle (shift = e^(jφ))
    % Complex wave shifted:     e^(jωt)e^(jφ) = e^(jωt + φ)
signal1 = 0.90 * exp(1j * phi1) * exp(1j * f_rad * t);
signal2 = 0.90 * exp(1j * phi2) * exp(1j * f_rad * t);


%% Verification of signals
% Select a window of time, frw, to view the complex waveform
% Frame to be shown can be selected with frn
% Period is 1 us or 0.000001 s

T = 1/f_hz; % Period of signal
frw = 6*T; % Frame width in seconds
frn = 100; % Frame number

% Select sample of s1 and s2 within the time frame
s1_framed = signal1((frn-1)*floor(frw*fs)+1:frn*floor(frw*fs));
s2_framed = signal2((frn-1)*floor(frw*fs)+1:frn*floor(frw*fs));

n = length(s1_framed); % Number of samples in framed s1
N = 2^(ceil(log2(n))); % Next power of 2 greater than n for FFT

% Create frequency domain plots
% Freq axis specified by N
f = (-fs/2:fs/N:fs/2-1);
f = [f zeros(1,N-length(f))];
% Zero padding before FFT
s1_padded = [s1_framed zeros(1,N-n)];
s2_padded = [s2_framed zeros(1,N-n)];
% Create FFTs of s1 and s2
s1_fdomain = fft(s1_padded);
s2_fdomain = fft(s2_padded);
% Shift all FFTs
s1_fdomain = 1/n*abs(fftshift(s1_fdomain));
s2_fdomain = 1/n*abs(fftshift(s2_fdomain));
% Create dB versions
s1_fdom_dB = 20.*log10(s1_fdomain);
s2_fdom_dB = 20.*log10(s2_fdomain);
% Plot frequency domain
figure('NumberTitle','off','Name','Frequency Domain', 'Units','normalized','Position',[0.3 0.2 0.5 0.5])
subplot(1,2,1)
semilogy(f,s1_fdom_dB,'Color', '#0072BD'); grid on;
title('Signal 1 (Frequency Domain)', 'Fontsize', 14)
xlabel('Frequency, (MHz)', 'Fontsize', 11)
ylabel('Magnitude, (dB)', 'Fontsize', 11)
xtickangle(45)
ax = gca;
ax.XAxis.Exponent = 6;
ax.YAxis.Exponent = 0;
xlim([-fs/2 fs/2])
subplot(1,2,2)
semilogy(f,s2_fdom_dB,'Color', '#EDB120'); grid on;
title('Signal 2 (Frequency Domain)', 'Fontsize', 14)
xlabel('Frequency, (MHz)', 'Fontsize', 11)
ylabel('Magnitude, (dB)', 'Fontsize', 11)
xtickangle(45)
ax = gca;
ax.XAxis.Exponent = 6;
ax.YAxis.Exponent = 0;
xlim([-fs/2 fs/2])

% Create time domain plots
% Time axis specified by frw and frn
t_plot = t((frn-1)*floor(frw*fs)+1:frn*floor(frw*fs));
% Resize signals for time domain frame
s1_tdomain = s1_padded(1:n);
s2_tdomain = s2_padded(1:n);
figure('NumberTitle','off','Name','Time Domain', 'Units','normalized','Position',[0.25 0.25 0.5 0.5])
% Plot real and imaginary parts of signal 1 in time domain
subplot(2,2,1)
s1_Re = real(s1_tdomain);
s1_Im = imag(s1_tdomain);
yyaxis left
plot(t_plot, s1_Re,'Color', '#0072BD'); grid on;
title('Signal 1 (Real and Imaginary Parts)', 'Fontsize', 14)
xlabel('Time (s)', 'Fontsize', 11)
ylabel('Re Magnitude', 'Fontsize', 11)
yyaxis right
plot(t_plot,s1_Im,'Color', '#D95319'); grid on;
ylabel('Im Magnitude', 'Fontsize', 11)
% Plot real and imaginary parts of signal 2 in time domain
subplot(2,2,2)
s2_Re = real(s2_tdomain);
s2_Im = imag(s2_tdomain);
yyaxis left
plot(t_plot, s2_Re,'Color', '#EDB120'); grid on;
title('Signal 2 (Real and Imaginary Parts)', 'Fontsize', 14)
xlabel('Time (s)', 'Fontsize', 11)
ylabel('Re Magnitude', 'Fontsize', 11)
yyaxis right
plot(t_plot,s2_Im,'Color', '#7E2F8E'); grid on;
ylabel('Im Magnitude', 'Fontsize', 11)
% Plot imaginary vs real parts of signal 1
subplot(2,2,3)
plot(s1_Re, s1_Im, '-','Color',	'#0072BD', 'LineWidth', 2); grid on;
hold on;
plot(s1_Re(1), s1_Im(1), 'k+', 'LineWidth', 2);
title('Signal 2 (Real and Imaginary Parts)', 'Fontsize', 14)
xlabel('Time (s)', 'Fontsize', 11)
ylabel('Re Magnitude', 'Fontsize', 11)
legend('Signal 1','Start','Location','northeastoutside')
axis square;
% Plot imaginary vs real parts of signal 2
subplot(2,2,4)
plot(s2_Re, s2_Im, '-','Color',	'#EDB120', 'LineWidth', 2); grid on;
hold on;
plot(s2_Re(1), s2_Im(1), 'k+', 'LineWidth', 2);
title('Signal 2 (Real and Imaginary Parts)', 'Fontsize', 14)
xlabel('Time (s)', 'Fontsize', 11)
ylabel('Re Magnitude', 'Fontsize', 11)
legend('Signal 2','Start','Location','northeastoutside')
axis square;


%% Save signals and combine into one file
% Save the signals to files
tx1_filename = 'element1.csv';
tx2_filename = 'element2.csv';

save_csv(tx1_filename, signal1); 
save_csv(tx2_filename, signal2);

tx1_table = readtable(tx1_filename);
tx2_table = readtable(tx2_filename);
tx2_table = renamevars(tx2_table,["Var1","Var2"],["Var3","Var4"]);
combined_table = [tx1_table tx2_table];
writetable(combined_table, combined_filename, 'Delimiter',',','WriteVariableNames',0);

delete element1.csv;
delete element2.csv;
    

end