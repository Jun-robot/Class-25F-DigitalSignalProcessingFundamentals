recObj = audiorecorder;
disp("Start Speaking");
recordblocking(recObj, 3);
disp("Stop recording");

play(recObj);
y = getaudiodata(recObj);

plot(y);
audiowrite('voice.wav', y, 8000);

