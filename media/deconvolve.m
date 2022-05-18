% deconvolve.m
%
% Given a system impulse response h[n] and test response y[n], this
% algorithm deconvolves the test response with the impulse response
% to determine the input x[n] as X(jw) = Y(jw)/H(jw).
%
% Eliminate some noise, but is still very rough
%
% NOTE: Assumes all signals are the same length. Use sigcorrect.m
% to equalize their lengths if they are different.
%
% use: deconvolve(impresp,test,testresp)
% variables: impresp: impulse response of system
%            test: test input to system
%            testresp: test response of system
%
% William Howison
% 12/11/2005

function deconvolve(impresp,test,testresp)

N = length(real(fft(impresp))); % determines the length of the signals

% creates a filter to roughly eliminate noise based on previous
% knowledge and tests on our test inputs
firstlast = ones(5e4,1);
middle = zeros(N-2*length(firstlast),1);

filter = [firstlast; middle; firstlast];

% selects output location to write the deconvolved sound file to
disp('Please select output file location')
[out_file, out_path] = uiputfile('*.wav', 'Select Output File');

HR = fft(impresp); % FFT of the impulse response of the system

T = fft(test); % FFT of original input
TR = fft(testresp); % FFT of the response of the system to the test signal

decon = (TR ./ HR); % naive deconvolution by division of FFTs

decon = decon.*filter; % rough filtering using above created filter

% iFFT the deconvolved signal to get an approximation of the input
decontime = real(ifft(decon));

% record the result (the approximated input) as a wave file
wavwrite(decontime,44100,[out_path out_file]);

% plot inputs and results for comparison versus time
timelength = N/44100; % time length of signals
increment = 1/44100; % increment to measure time axis by
time = increment:increment:timelength; % create time axis

subplot(4,1,1)
plot(time, test) % plots the original input recorded
title('Original input')

subplot(4,1,2)
plot(time, decontime) % plots the deconvolved result
title('Deconvolved result (approx. input)')

subplot(4,1,3)
semilogy(real(abs(T))) % plot real part of original input's spectrum
title('Real spectrum magnitude of original input')

subplot(4,1,4)
semilogy(real(abs(decon))) % plot real part of result's spectrum
title('Real spectrum magnitude of deconvolved result')