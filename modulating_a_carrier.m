% Recall the canonical sine wave is A(t)*sin(2PI * f(t) * t + phi(t))

sample_rate = 10000;
t = [0:1/sample_rate:2]; % This construct is inclusive

amp_carrier = 20;
freq_carrier = 4500;

amplitude_sensitivity = 1;
freq_mod = 5 * sin(2*pi*t) + 10;

% This breaks, not sure why, but the envelope gets fucked
% amp_m = sin(2*pi*t) + 1; 
amp_m = ones(1,numel(t));

m = (amp_carrier * amplitude_sensitivity .* amp_m) .* sin(2*pi*t .* freq_mod); % So our modulating signal is a 2Hz Sine

% https://www.tutorialspoint.com/analog_communication/analog_communication_am_modulators.htm
% This shows it as a summation...

carrier = amp_carrier .* sin(2 * pi * freq_carrier * t);
x = (1 + m ./ amp_carrier) .* carrier;

rectified = x;
rectified( rectified <= 0) = 0;

filtered = lowpass(rectified, 5, sample_rate);

tiledlayout(5,1);
nexttile;
plot(m);

nexttile;
plot(carrier);

nexttile;
plot(x);

% What even is this mixing shit
% nexttile;
% plot(x .* carrier);

nexttile;
plot(rectified);

nexttile;
plot(filtered);