% 1DDEMO01 Demonstrate 1-D Gabor functionality
%
% References:
%   [1] Kamarainen, J.-K., Kyrki, V., Kalviainen, H., Gabor
%       Features for Invariant Object Recognition, Research
%       report 78, Department of Information Technology,
%       Lappeenranta University of Technology 
%
% Author(s):
%    Joni Kamarainen <Joni.Kamarainen@lut.fi>
%    Ville Kyrki <Ville.Kyrki@lut.fi>
%
% Copyright:
%
%   The Gabor Features in Signal and Image Processing Toolbox is
%   Copyright (C) 2000 by Joni Kamarainen and Ville Kyrki.
%
%
%   $Name: V_0_4 $ $Revision: 1.2 $  $Date: 2003/03/03 10:51:17 $
%
function [] = gfdemo01;

disp('Step 1: GENERATE TEST FUNCTION');
disp('Let''s construct a test signal from two different components:');
disp('(1) first component is N(0,1) white noise from t=1..1000');
t = [0:999];
w = randn(1,1000);
plot(t,w,'LineWidth',1);
input('<RETURN>');
disp('(2) and second component a Sin signal of frequency 1/10 and amplitude 2 at t=501..600 .');
sin100wl = 10;
sing100length = 100;
sin100 = [zeros(1,500) 2*sin(2*pi*1/sin100wl*[1:100]) zeros(1,400)];
plot(t,sin100,'LineWidth',1);
input('<RETURN>');
disp('Two signals together.');
x = w+sin100;
plot(t,x,'LineWidth',1);
input('<RETURN>');

% create 1-D spatial Gabor filter
disp('Step 2: FILTER WITH TIME DOMAIN GABOR FILTER');
disp('Let''s try to catch the sin-signal by time domain Gabor filter on same frequency 1/10');
disp('and with Gamma value 1. Filter size would be for example 101.');
gwl = 10;
gamma = 1;
g = gfcreatefilter(1/gwl,gamma,101);
plot(1:101,real(g),'k-',1:101,imag(g),'b-','LineWidth',1);
legend('Re','Im');
input('<RETURN>');

% filter signal with given filter and plot magnitude
disp('If the test signal x and filter g are now convolved conv(g,x)');
disp('we can calculate the magnitudes of the filter response (note response at t=501..600)');
resp1 = conv(g,x);
plot(t,abs(resp1(51:1050)).^2,'LineWidth',1);
input('<RETURN>');

% convert signal to Fourier domain
disp('Step 3: FILTER WITH FREQUENCY DOMAIN GABOR FILTER');
disp('For faster computation we can transform x to Fourier domain X=fft(x)');
X = fft(x);
plot(1:1000,real(X),1:1000,imag(X),'LineWidth',1);
legend('Re','Im');
input('<RETURN>');

disp('and generate frequency domain Gabor filter G');
G = gfcreatefilterf(1/gwl,gamma,1000);
plot(G,'LineWidth',1);
legend('Only Re component');
input('<RETURN>');

% calculate response in Freq domain
disp('Now the convolution is a multiplication in the frequency domain');
RESP = X.*G;
plot(1:1000,real(RESP),1:1000,imag(RESP),'LineWidth',1);
legend('Re','Im');
input('<RETURN>');

% back to time domain and plot response
disp('which can be of course transformed back to time domain')
resp2 = ifft(RESP);
plot(t,abs(resp1(51:1050)).^2,'k-',t,abs(resp2).^2,'r--','LineWidth',1);
legend('time domain response','frequecy domain response in time domain');
input('<RETURN>');

gfplotfiltersf(1./(1*2.^[1 2 3 4]),[1 1 1 1],100);
title('GFPLOTFILTERSF');
disp('1-D Gabor filters can be used to localize and detect signals in');
disp('both, time and frequency, domains simultaneously');
