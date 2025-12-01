Fs = 8000;
sep = power(2,1/12);

A = 440;
C = A * power(sep,3);
E = A * power(sep,7);

t = (0:1/Fs:2);
y = 0.2* (sin(2*pi*(A)*t)+sin(2*pi*(C)*t)+sin(2*pi*(E)*t));



sound(y, Fs);
plot(t(1:100), y(1:100));