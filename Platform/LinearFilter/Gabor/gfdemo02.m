% GFDEMO02 Demonstrate 2-D Gabor functionality
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
%   $Name:  $ $Revision: 1.1 $  $Date: 2003-12-23 07:27:55 $
%      
function [] = gfdemo02;

disp('Step 1: GENERATE TEST IMAGE');
img = 0.1*randn(128,128);
img(50:60,50:60) = 1;
imagesc(img);
colormap(gray);
input('<RETURN>');

% create 1-D spatial Gabor filter
disp('Step 2: FILTER WITH 2D TIME DOMAIN GABOR FILTER');
f = 0.2;
theta = 0;
gamma = 1;
eta = 1;
g = gfcreatefilter2(f,theta,gamma,eta,[60 60]);
disp('Real part of the filter');
imagesc(real(g));
colormap(gray);
input('<RETURN>');

% filter signal with given filter and plot magnitude
disp('If the image i(x,y) and filter g(x,y) are now convolved conv(g,x)');
disp('we can calculate the magnitudes of the filter response.');
resp1 = conv2(img,g,'same');
imagesc(abs(resp1).^2);
colormap(gray);
colorbar;
input('<RETURN>');

% convert signal to Fourier domain
disp('Step 3: FILTER WITH 2D FREQUENCY DOMAIN GABOR FILTER');
disp('For faster computation we can transform x to Fourier domain X=fft(x)');
disp(['and generate frequency domain Gabor filter G for conv2 or we' ...
      ' may just use gfrespf2 as']);
G = gfcreatefilterf2(f,theta,gamma,eta,[size(img,2) size(img,1)]);
resp2 = gfrespf2(G,img);
imagesc(abs(resp1).^2);
colormap(gray);
colorbar;
input('<RETURN>');

% Frequency domain filter in one point
disp('Step 4: FILTER WITH 2D FREQUENCY DOMAIN GABOR FILTER IN ONE LOCATION');
disp('For faster computation we can transform x to Fourier domain X=fft(x)');
disp(['and generate frequency domain Gabor filter G for conv2 or we' ...
      ' may just use gfrespf2 as']);
G = gfcreatefilterf2(f,theta,gamma,eta,[size(img,2) size(img,1)]);
resp3 = gfrespf2(G,img,16,21);
disp('Response:');
disp(resp3);
input('<RETURN>');
