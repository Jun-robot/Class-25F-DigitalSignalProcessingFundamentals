%% fft of harmony A.m
%
% generate a 440Hz tone
Fs = 8000; % sampling rate
A = 440; %tone frequency
period = 0.02; %signal length in second
t = (0:1/Fs:period-1/Fs);
f = (1/period:1/period:Fs);
sep = power(2, 1/12);
Cs = A*power(sep, 4)
E = Cs*power(sep, 3)
% we reduce the amplitude by 0.2 to avoid distortion.
y = 0.2*sin(2*pi*(A)*t) + 0.2*sin(2*pi*Cs*t) + 0.2*sin(2*pi*E*t);
sound(y, Fs);
fy = fft(y);
plot(f, abs(fy)/length(t));
xlabel('frequency (Hz)')
ylabel('gain')