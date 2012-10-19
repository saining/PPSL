%GFCREATEFILTERF Create normalized 1-D Gabor filter in the frequency domain.
%
%   [G] = GFCREATEFILTERF(F0,GAMMA,N,...) creates a normalized Gabor
%   filter G of size N with central frequency F0, normalized width GAMMA.
%
%   G = GFCREATEFILTER(...,'PF',PF) determines that at least
%   P percent of the Gaussian envelope of the filter must be
%   included in the filter in frequency domain. For default,
%   PF=0.998. 
%
%   G = GFCREATEFILTER(...,'PT',PT) determines that at least
%   P percent of the Gaussian envelope of the filter must be
%   included in the filter in time domain. For default,
%   PT=0.998. 
%
%   Examples
%
%   See also GFCREATEFILTER, GFCHECKFILTER.
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
%   $Name: V_0_4 $ $Revision: 1.10 $  $Date: 2003/02/23 16:27:44 $
%
function [g]=gfcreatefilterf(f0,gamma,N,varargin)

%
% Setting default values
alpha = f0/gamma;
PT = 0.998;
PF = 0.998;

%
% Parameter parsing
currentarg = 1;
while (length(varargin) > currentarg)
  [param,value]=deal(varargin{currentarg:currentarg+1});
  switch lower(param)
   case 'pt'
    PT = value;
   case 'pf'
    PF = value;
   otherwise
    error(['Unknown parameter ''' param '''.']);
  end;
  currentarg=currentarg+2;
end;

% Check filter constraints
gfcheckfilter(f0,gamma,N,PT,PF);

% Creating the bank
n = -N:1:N;
nyqf = 0.5; % Nyquist frequency 
u = n/N; % frequencies that bank contains

% Create filter values
g = zeros(1,N);
gf = exp(-(pi^2/alpha^2)*(u-f0).^2); 
g = gf((N+1):(2*N)); % frequencies from 0 to (N-1)/N
g = g+gf(1:N); % aliased frequencies



