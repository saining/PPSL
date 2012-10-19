%GFPLOTFILTERSF Plot 1-D normalized Gabor filters in the frequency domain.
%
%   GFPLOTFILTERS(F0,GAMMA,N) creates a normalized Gabor
%   filters 1..K for parameters (F0(1),GAMMA(1))...(F0(K),GAMMA(K))
%   and of size N and plots the filters in the frequency domain.
%
%   Examples
%
%   See also GFCREATEFILTERF, GFCHECKFILTER.
%
% References:
%   [1] Kamarainen, J.-K., Kyrki, V., Kalviainen, H., Gabor
%       Features for Invariant Object Recognition, Research
%       report 79, Department of Information Technology,
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
%   $Name: V_0_4 $ $Revision: 1.4 $  $Date: 2003/02/23 16:27:44 $
%
function []=gfplotfiltersf(f0,gamma,N)

% Creating the bank
n = -N:1:N;
nyqf = 0.5; % Nyquist frequency 
u = n/N; % frequencies that bank contains

for ind = 1:length(f0)
  g = gfcreatefilterf(f0(ind), gamma(ind), N);
  plot(g);
  hold on;
end;
hold off;

%% plot frequencies in more nicer form
%xticks = [];
%for i = 0:N/10:N
%  xticks = [xticks; sprintf('%5d/%5d\n', i, N)];
%end;
%set(gca, 'XTickLabel',xticks)   
%yticks = [];
%for i = 30:20:200
%  yticks = [yticks; sprintf('1/%3d\n', i)];
%end;
%set(gca, 'YTickLabel',yticks)   

xlabel('discrete frequency  [u]');
ylabel('magnitude');


