function complex_signal_generator()
% ORDER OF OPERATIONS: 
%   1. Open this file and press run to create or update the .csv file
%   2. WAIT FOR THE FILE TO GENERATE - ITS BIG AND TAKES SOME TIME!!!

% Function to generate a complex sinusoid signal's I/Q samples

clear; close all; clc;

%% Get desired beam angle
% Get user input for the desired beam angle of the signal
prompt = {'Enter beam angle, (degrees):'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'0'};
user_input = inputdlg(prompt,dlgtitle,dims,definput);

% Name output files based on desired beam angle
leader_filename = strcat('leader_',user_input{1},'.csv');
follower_filename = strcat('follower_',user_input{1},'.csv');
combined_filename = strcat('combined_',user_input{1},'.csv');

% User defined beam angle, b°, in degrees
beam_angle = str2double(user_input{1});

% Phase shift, phi or φ, between elements in radians, φ = pi*sin(b°/180 * π)
phi=pi*sin(beam_angle*(pi/180));

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
fm_hz = 1e6; % Will be 1e6
fm_rad = fm_hz * 2 * pi;

% Carrier signal frequency, in radians (ω = F_Hz * 2π)
fc_hz = 2.285e9; % Will be 2.285e9
fc_rad = fc_hz * 2 * pi;

% Element phase shifts
phi1 = phi*0;
phi2 = phi*1;
phi3 = phi*2;
phi4 = phi*3;

% Generate a vector "t" which represents time, in units of samples.
% This starts at t=0, and creates n samples in steps of 1/SAMPLE_RATE
t = 0 : (1/fs) : (seconds - 1/fs);

% Create a sinusoid (signal = e^(jωt) ) with a magnitude of 0.90
    % Eulers equation:         e^(jωt) = cos(ωt) + jsin(ωt)
% Shift signal by specified angle (shift = e^(jφ))
    % Complex wave shifted:     e^(jωt)e^(jφ) = e^(jωt + φ)
message_signal1 = 0.90 * exp(1j * phi1) * exp(1j * fm_rad * t);
message_signal2 = 0.90 * exp(1j * phi2) * exp(1j * fm_rad * t);
message_signal3 = 0.90 * exp(1j * phi3) * exp(1j * fm_rad * t);
message_signal4 = 0.90 * exp(1j * phi4) * exp(1j * fm_rad * t);

%% Save signals and combine into one file
% Save the signals to files
tx1_filename = 'element1.csv';
tx2_filename = 'element2.csv';
tx3_filename = 'element3.csv';
tx4_filename = 'element4.csv';

save_csv(tx1_filename, message_signal1); 
save_csv(tx2_filename, message_signal2); 
save_csv(tx3_filename, message_signal3); 
save_csv(tx4_filename, message_signal4);

tx1_table = readtable(tx1_filename);
tx2_table = readtable(tx2_filename);
tx3_table = readtable(tx3_filename);
tx4_table = readtable(tx4_filename);
tx2_table = renamevars(tx2_table,["Var1","Var2"],["Var3","Var4"]);
tx4_table = renamevars(tx4_table,["Var1","Var2"],["Var3","Var4"]);
leader_table = [tx1_table tx2_table];
follower_table = [tx3_table tx4_table];
follower_table = renamevars(follower_table,["Var1","Var2","Var3","Var4"],["Var5","Var6","Var7","Var8"]);
combined_table = [leader_table follower_table];
writetable(leader_table, leader_filename, 'Delimiter',',','WriteVariableNames',0);
writetable(follower_table, follower_filename, 'Delimiter',',','WriteVariableNames',0);
writetable(combined_table, combined_filename, 'Delimiter',',','WriteVariableNames',0);

delete element1.csv;
delete element2.csv;
delete element3.csv;
delete element4.csv;