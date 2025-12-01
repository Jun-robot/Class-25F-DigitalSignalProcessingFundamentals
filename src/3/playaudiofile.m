
[y, Fs] = audioread('voice.wav');

coef = input('input stretch = ');

sound(y, Fs*coef);




