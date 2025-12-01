%% tone440.m  
%% generate a 440Hz tone 
Fs = 8000; 
f = 440; 
t = (0:1/Fs:2); 

y = [sin(2*pi*f*t); sin(2*pi*f*t*sqrt(2))];

sound(y, Fs); 
plot(t(1:100), y(1:100)); 
% we only draw first 100 samples