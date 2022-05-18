% sigcorrect.m
%
% truncates an input from its first non-noise value to be shorter,
% then zero pads to length N. outputs a length N signal
%
% use: out = sigcorrect(orig,N)
%
% assumes a sampling rate of 44.1 kHz
% N must be greater than 132300
%
% William Howison
% 12/11/2005

function out = sigcorrect(orig,N)

for i=1:length(orig) % cycles through the signal
    if orig(i) > .2  % until it finds a value greater than .2
        
        firstb = i;  % saves the location of that value
        break
    end
end

if length(orig) < 441000 % make 2 truncation lengths
    
    L = 88200; % truncate to 2 seconds for shorter inputs
else
    L = 441000; % truncate to 10 secs for longer inputs
end

trunc = orig(firstb:firstb+L-1); % truncate from above location

zerovect = zeros(10000,1); % vector of zeros to pad with

n = N - L;    % length to pad with zeros

index = fix(n/10000); % number of times n divides by 10000 evenly
remainder = rem(n,10000); % remainder of n/10000

for j = 1:index % concatenate zeros 'index' # of times onto trunc
    
    trunc = [trunc; zerovect];
end

% concatenate any fractions of the zeros vector that are not 10000 length
if remainder ~= 0
    
    % concatenates 'remainder' length part of zeros vector
    out = [trunc; zerovect(1:remainder)];
else
    
    % if N is an exact multiple of 10000, no need to add more
    out = trunc;
end