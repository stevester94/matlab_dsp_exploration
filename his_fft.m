% NOTE, changing the number of time points also fucks his example with the
% same exact scaling problem.

% https://medium.com/analytics-vidhya/breaking-down-confusions-over-fast-fourier-transform-fft-1561a029b1ab
clear;
clc;
Fs = 1000;          %sampling rate
T = 1/Fs;           %sampling interval
L = 4000;            %Number of time points
t = 0:T:(L-1)*T;    %time vector
N = 1024;           %FFT points
% Define frequencies
f1 = 20;
f2 = 220;
f3 = 138; 
% Create the signal
x  = 5 + 12*sin(2*pi*f1*t-0.3) + 5*sin(2*pi*f2*t-0.5) + 4*sin(2*pi*f3*t - 1.5);
figure(1)
plot(t*1000,x)
xlabel('time (in ms)')
ylabel('Amplitude')
title('Original Signal')
% Add some noise
figure(2)
% x = awgn(x,5,'measured')
plot(t*1000,x)
xlabel('time (in ms)')
ylabel('Amplitude')
title('Noisy Signal')

% FFT
X = fft(x,N);
figure(3)
plot(abs(X))

% FFT output is apparently complex valued. Each IQ is (amplitude, phase)
% for the given frequency

% FFT returns a mirror reflection across the midpoint for real signals
% Something about complex conjugates.
% We only need the Single Side Band Spectrum
% We get this by only taking the first half of the output, and multiplying
% it by 2 (I suppose to compensate for nuking half the output).
SSB = X(1:N/2);
SSB(2:end) = 2*SSB(2:end); % They go to to end because the first element corresponds to DC component (0 phase).

% The frequency axis. We specify the number of points (Bins) for our FFT.
% This is actually a little different than what I thought. I thought the
% number of points was determined by the length of the input...
% Well at any rate, we are throwing away half the bins anyways. So, we are
% spreading Fs/2 Hz across N/2 bins

f = (0:N/2-1)*(Fs/N);
% Amplitude
figure(4)
% plot(f,abs(SSB/L)) % Something to do with a normalization factor, regarding the input signal length.
plot(f,abs(SSB/numel(t))) % Something to do with a normalization factor, regarding the input signal length.
xlabel('f (in Hz)')
ylabel('|X(f)|')
title('Corrected Frequency Spectrum')