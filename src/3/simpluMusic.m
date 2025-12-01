%
% simple music play
%
clear;
frameLength = 1024; % length of a frame
mfile = uigetfile('*.mp3'); %mp3 file
fileReader = dsp.AudioFileReader(...
mfile,...
'SamplesPerFrame',frameLength);
Fs = fileReader.SampleRate;
deviceWriter = audioDeviceWriter(...
'SampleRate',Fs);% audio system define
while ~isDone(fileReader)
    signal = fileReader(); % read frameLength samples from the mp3 file
    deviceWriter(signal); % write to audio device
end
release(fileReader);
release(deviceWriter);