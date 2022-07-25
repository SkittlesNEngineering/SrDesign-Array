function [ signal1, signal1_i, signal1_q, signal2, signal2_i, signal2_q] = load_csv(filename)
% LOAD_SC16Q11 Read a normalized complex signal from a CSV file
%              with integer bladeRF "SC16 Q11" values.
%
%   [SIGNAL, SIGNAL_I, SIGNAL_Q] = load_csv(FILENAME)
%
%   FILENAME is the source filename.
%
%   SIGNAL is a complex signal with the real and imaginary components
%   within the range [-1.0, 1.0).
%
%   SIGNAL_I and SIGNAL_Q are optional return values which contain the
%   real and imaginary components of SIGNAL as separate vectors.
%
    csv = load(filename);
    signal1_i = csv(:, 1) ./ 2048.0;
    signal1_q = csv(:, 2) ./ 2048.0;
    signal2_i = csv(:, 3) ./ 2048.0;
    signal2_q = csv(:, 4) ./ 2048.0;
    signal1 = signal1_i + 1j .* signal1_q;
    signal2 = signal2_i + 1j .* signal2_q;
end