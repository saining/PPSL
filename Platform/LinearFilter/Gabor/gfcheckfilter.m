%GFCHECKFILTER Check filter parameters.
%
%   GFCHECKFILTER(F0,GAMMA,N,PT,PF)  Checks the constraints of the
%   discrete Gabor filter for given parameters and prints out
%   warning messages.
%
%     F0    - Central frequency
%     GAMMA - Sharpness factor
%     N     - Size of the filter
%     PT    - Time domain percent factor
%     PF    - Frequency domain Percent factor
%
%   Examples
%
%     gfcheckfilter(1/64, 1, 64, 0.998, 0.998);
%
%   See also GFCREATEFILTER, GFCREATEFILTERF.
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
%   $Name: V_0_4 $ $Revision: 1.6 $  $Date: 2003/02/23 16:27:44 $
%
function []=gfcheckfilter(f0,gamma,N,PT,PF)

% Set checking values
alpha = f0/gamma;
nyqf = 0.5; % Nyquist frequency 

%
% Checking Nyquist criterion
if (f0 > nyqf)
  warning('Nyquist criterion violated');
end;

%
% Checking spatial constraints

% Symmetric part of the filter must contain pt percent of the
% full filter envelope 

fPT = erf(alpha*floor((N-1)/2));
if (fPT < PT)
  warning(['Spatial filter size may be too small. '...
	   ' Requested minimum spatial envelope size is '...
	   num2str(PT*100) ' percent and current size is '...
	   num2str(100*fPT)]);
end;

%
%  Checking frequency constraints
fPF = erf(pi/alpha*f0);
if (fPF < PF)
  warning(['Filter envelope insufficiently located in the frequency domain. '...
	   ' Requested minimum envelope area inside domain is '...
	   num2str(100*PF) ' percent and currently area is ' ...
	   num2str(100*fPF)]);
end;











