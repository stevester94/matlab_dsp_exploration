clear;
clc;
Fs = 1000;          %sampling rate
Duration = 10;

t = 0:1/Fs:Duration;    %time vector
N = 1024;           %FFT points

% Create the signal
amplitude = 12;
frequency = 400;
phase_offset = -0.3;
dc_offset = 0;
x = dc_offset + amplitude * sin(2*pi*frequency*t + phase_offset);

figure(1)
plot(t*1000,x)
xlabel('time (in ms)')
ylabel('Amplitude')
title('Original Signal')

% FFT
X = fft(x,N);
figure(3);
plot(X);

% FFT returns a mirror reflection across the midpoint for real signals
% Something about complex conjugates.
% We only need the Single Side Band Spectrum
% We get this by only taking the first half of the output, and multiplying
% it by 2 (I suppose to compensate for nuking half the output).
SSB = X(1:N/2);
SSB(2:end) = 2*SSB(2:end); % They start at 2 because first element corresponds to DC component (0 freq).

% FFT output is apparently complex valued. Each IQ is (amplitude, phase)
% for the given frequency. abs of a complex returns the magnitude of the
% complex. Now, why we do this instead of just using the I portion I am not
% sure.
% SSB = abs(SSB);

% The frequency axis. We specify the number of points (Bins) for our FFT.
% This is actually a little different than what I thought. I thought the
% number of points was determined by the length of the input...
% Well at any rate, we are throwing away half the bins anyways. So, we are
% spreading Fs/2 Hz across N/2 bins -> (Fs/2)/(N/2)=(Fs/N)

f = (0:N/2-1)*(Fs/N); % The -1 is due to dropping the first bin.


normalized_SSB = abs(SSB)/length(t);

% Amplitude
figure(4)
plot(f, normalized_SSB); % Something to do with a normalization factor, regarding the input signal length.
xlabel('f (in Hz)')
ylabel('|X(f)|')
title('Corrected Frequency Spectrum')