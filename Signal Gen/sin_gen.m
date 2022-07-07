function sin_gen()
% function to generate a sine signal - modified version of what Samuel 
%   created

% importnat note: Number   of   samples   per  buffer  to  use  in  the
%   asynchronous stream.  Must be divisible by  1024 and >= 1024

clear; clc;


fs= 500*(10^9);
f = 2.4*(10^9);
dt = 1/fs;
dur = (1/f)*5;
t = 0 : dt : dur-dt;
Amp = 0.001;

% signal
x = Amp* sin(2*pi*f*t);
figure('Name','Sine Signal')
plot(t,x)
xlabel('Time (s)');
ylabel('Amplitude');


save_csv('sin_gen.cvs', x);

end