% impulse.m | 4/17/2002
% -----------------------------------------------------
% This file produces the output file 'test_impulse.wav'
% containing an approximation to the unit impulse
% (delta) function.  The value of alpha on [0,1]
% determines the bandlimit of the approximation.
% This method is used to avoid the technical
% difficulties in producing (and reproducing) an
% ideal impulse (delta) function in audio.
%
% This file also produces the .wav audio file 
% 'test_audio.wav' which is an audio test vector
% intended to be used in the impulse response
% inversion experiment. (4/24/2002)
%
% NOTE: Impulse is bandlimited to alpha*Fmax where
% Fmax = Fs/2, or the Nyquist frequency.

Fs = 44100;   % sampling rate
T = 4;        % signal duration
tmax = Fs*T;  % number of samples
t0 = tmax/2;  % center time of approximated impulse

tlow = 1:t0-1;     % lower time interval (to avoid singularity [t=t0])
thigh = t0+1:tmax; % higher time interval (to avoid singularity [t=t0])

alpha = 0.25;      % impulse approx. factor (pure impulse when alpha = 1)

% construct piecewise continuous signal (defined at t-t0=0)
xlow = sin((pi*alpha)*(tlow-t0))./(tlow-t0);
xhigh = sin((pi*alpha)*(thigh-t0))./(thigh-t0);
x1=[xlow,1,xhigh];

pad = .5;  % gain factor used to avoid clipping on writing to .wav output

x1 = x1 ./ max(abs(x1));               % normalize signal vector
x1 = x1 .* (pad * hann(length(x1)))';  % pad and window signal for continuity

X1 = fft(x1);  % DFT of approximate impulse

time = 1/Fs : 1/Fs : T;
subplot(2,2,1);
plot(time, x1);
title('x1(t) - approx impulse function (alpha = 0.25)');
xlabel('seconds');

Z = -2*pi : (4*pi/(tmax-1)) : 2*pi;
subplot(2,2,2);
plot(Z, abs(X1));
title('|X1(Z)| - DFT of synthetic impulse');
xlabel('Z = exp(jw) : (w = [-2*pi, 2*pi])');

wavwrite(x1,Fs,'test_impulse.wav');

% produce test audio vector
pad_4 = zeros(1,4*Fs);
pad_6 = zeros(1,6*Fs,1);
test_audio = [pad_6,x1,pad_6,x1,x1,x1,pad_4];
wavwrite(test_audio,Fs,'test_audio.wav');