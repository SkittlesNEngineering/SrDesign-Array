function complex_signal_generator()
% ORDER OF OPERATIONS: 
%   1. Open this file and press run to create or update the .csv file
%   2. WAIT FOR THE FILE TO GENERATE - ITS BIG AND TAKES SOME TIME!!!

% Function to generate a complex sine signal

clear; close all; clc;
combined_filename = 'leader_zero.csv';
sig1_deg = 0;
sig2_deg = 0;

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

% Message signal frequency, in radians (ω = F_Hz * 2π)
fm_hz = 1e3; % Will be 1e6
fm_rad = fm_hz * 2 * pi;

% Carrier signal frequency, in radians (ω = F_Hz * 2π)
fc_hz = 1e6; % Will be 2.285e9
fc_rad = fc_hz * 2 * pi;

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
message_signal1 = 0.90 * exp(1j * phi1) * exp(1j * fm_rad * t);
message_signal2 = 0.90 * exp(1j * phi2) * exp(1j * fm_rad * t);

% Generate carrier signal
carrier_signal = 0.9 * exp(1j * fc_rad * t);

%% Verification of signals
% Select a window of time, frw, to view the complex waveform
% Frame to be shown can be selected with frn
% Period is 1 us or 0.000001 s

T = 1/fm_hz; % Period of message signal
frw = 1.6*T; % Frame width in seconds
frn = 5; % Frame number

% Select sample of s1 and s2 within the time frame
s1_framed = message_signal1((frn-1)*floor(frw*fs)+1:frn*floor(frw*fs));
s2_framed = message_signal2((frn-1)*floor(frw*fs)+1:frn*floor(frw*fs));
sc_framed = carrier_signal((frn-1)*floor(frw*fs)+1:frn*floor(frw*fs));

n = length(s1_framed); % Number of samples in framed s1
N = 2^(ceil(log2(n))); % Next power of 2 greater than n for FFT

% Create frequency domain plots
% Freq axis specified by N
f = (-fs/2:fs/N:fs/2-1);
f = [f zeros(1,N-length(f))];
% Zero padding before FFT
s1_padded = [s1_framed zeros(1,N-n)];
s2_padded = [s2_framed zeros(1,N-n)];
sc_padded = [sc_framed zeros(1,N-n)];
% % Create FFTs of s1 and s2
% s1_fdomain = fft(s1_padded);
% s2_fdomain = fft(s2_padded);
% sc_fdomain = fft(sc_padded);
% % Shift all FFTs
% s1_fdomain = 1/n*abs(fftshift(s1_fdomain));
% s2_fdomain = 1/n*abs(fftshift(s2_fdomain));
% sc_fdomain = 1/n*abs(fftshift(sc_fdomain));
% % Create dB versions
% s1_fdom_dB = 20.*log10(s1_fdomain);
% s2_fdom_dB = 20.*log10(s2_fdomain);
% sc_fdom_dB = 20.*log10(sc_fdomain);

%% Simulate mixer
% Time axis specified by frw and frn
t_plot = t((frn-1)*floor(frw*fs)+1:frn*floor(frw*fs));
% Resize signals for time domain frame
s1_tdomain = s1_padded(1:n);
s2_tdomain = s2_padded(1:n);
sc_tdomain = sc_padded(1:n);
% Multiplication in time domain
mix1_Re_tdomain = real(s1_tdomain).*real(sc_tdomain);
mix1_Im_tdomain = imag(s1_tdomain).*imag(sc_tdomain);
mix2_Re_tdomain = real(s2_tdomain).*real(sc_tdomain);
mix2_Im_tdomain = imag(s2_tdomain).*imag(sc_tdomain);
% % Convolution in frequency domain
% mix1_fdomain = conv(s1_fdomain,sc_fdomain);
% mix1_fdomain = mix_fdomain(N/2+1:3*N/2);

% % Plot frequency domain
% figure('NumberTitle','off','Name','Frequency Domain', 'Units','normalized','Position',[0.3 0.2 0.5 0.5])
% subplot(1,2,1)
% plot(f,s1_fdom_dB,'Color', '#0072BD'); grid on; hold on;
% plot(f,s2_fdom_dB,'Color', '#D95319');
% plot(f,sc_fdom_dB,'Color', '#EDB120');
% title('Messages and Carrier (Frequency Domain)', 'Fontsize', 14)
% xlabel('Frequency, (MHz)', 'Fontsize', 11)
% ylabel('Magnitude, (dB)', 'Fontsize', 11)
% xtickangle(45)
% ax = gca;
% ax.XAxis.Exponent = 6;
% ax.YAxis.Exponent = 0;
% xlim([-fs/2 fs/2])
% ylim([-100 10])
% subplot(1,2,2)
% plot(f,mix_fdomain,'Color', '#5EBF7A'); grid on;
% title('fm*fc (Frequency Domain)', 'Fontsize', 14)
% xlabel('Frequency, (MHz)', 'Fontsize', 11)
% ylabel('Magnitude, (dB)', 'Fontsize', 11)
% xtickangle(45)
% ax = gca;
% ax.XAxis.Exponent = 6;
% ax.YAxis.Exponent = 0;
% xlim([-fs/2 fs/2])
% ylim([-10 10])

% Create time domain plots
figure('NumberTitle','off','Name','Mixed Signals Time Domain','WindowState','maximized')
% Plot mix of signal 1 and carrier
subplot(1,2,1)
yyaxis left
plot(t_plot(1:50), mix1_Re_tdomain(1:50),'Color', '#4DBEEE'); grid on;
title('Message 1 and Carrier (Real and Imaginary Parts)', 'Fontsize', 14)
xlabel('Time (s)', 'Fontsize', 11)
ylabel('Re Magnitude', 'Fontsize', 11)
ax = gca;
ax.YColor = '#4DBEEE';
yyaxis right
plot(t_plot(1:60),mix1_Im_tdomain(1:60),'Color', '#0077AA'); grid on;
ylabel('Im Magnitude', 'Fontsize', 11)
ax = gca;
ax.YColor = '#0077AA';
% Plot mix of signal 2 and carrier
subplot(1,2,2)
yyaxis left
plot(t_plot(1:68), mix2_Re_tdomain(1:68),'Color', '#EE4466'); grid on;
ax = gca;
ax.YColor = '#EE4466';
title('Message 2 and Carrier (Real and Imaginary Parts)', 'Fontsize', 14)
xlabel('Time (s)', 'Fontsize', 11)
ylabel('Re Magnitude', 'Fontsize', 11)
yyaxis right
plot(t_plot(1:68),mix2_Im_tdomain(1:68),'Color', '#AA1133'); grid on;
ylabel('Im Magnitude', 'Fontsize', 11)
ax = gca;
ax.YColor = '#AA1133';
% % Plot imaginary vs real parts of signal 1
% subplot(2,2,3)
% plot(mix1_Re_tdomain, mix1_Im_tdomain, '-','Color',	'#0072BD', 'LineWidth', 2); grid on;
% hold on;
% plot(mix1_Re_tdomain(1), mix1_Im_tdomain(1), 'k+', 'LineWidth', 2);
% title('Signal 2 (Real and Imaginary Parts)', 'Fontsize', 14)
% xlabel('Time (s)', 'Fontsize', 11)
% ylabel('Re Magnitude', 'Fontsize', 11)
% legend('Signal 1','Start','Location','northeastoutside')
% axis square;
% % Plot imaginary vs real parts of signal 2
% subplot(2,2,4)
% plot(mix2_Re_tdomain, mix2_Im_tdomain, '-','Color',	'#EDB120', 'LineWidth', 2); grid on;
% hold on;
% plot(mix2_Re_tdomain(1), mix2_Im_tdomain(1), 'k+', 'LineWidth', 2);
% title('Signal 2 (Real and Imaginary Parts)', 'Fontsize', 14)
% xlabel('Time (s)', 'Fontsize', 11)
% ylabel('Re Magnitude', 'Fontsize', 11)
% legend('Signal 2','Start','Location','northeastoutside')
% axis square;


%% Save signals and combine into one file
% Save the signals to files
tx1_filename = 'element1.csv';
tx2_filename = 'element2.csv';

save_csv(tx1_filename, message_signal1); 
save_csv(tx2_filename, message_signal2);

tx1_table = readtable(tx1_filename);
tx2_table = readtable(tx2_filename);
tx2_table = renamevars(tx2_table,["Var1","Var2"],["Var3","Var4"]);
combined_table = [tx1_table tx2_table];
writetable(combined_table, combined_filename, 'Delimiter',',','WriteVariableNames',0);

delete element1.csv;
delete element2.csv;