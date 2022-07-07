clear; clc;
fs= 500*(10^9);
f = 2.4*(10^9);
dt = 1/fs;
dur = (1/f)*5;
t = 0 : dt : dur-dt;
Amp = 0.001;
x = Amp* sin(2*pi*f*t);
figure('Name','Sine Signal')
plot(t,x)
xlabel('Time (s)');
ylabel('Amplitude');

writematrix(x, 'sine_sig.csv')
