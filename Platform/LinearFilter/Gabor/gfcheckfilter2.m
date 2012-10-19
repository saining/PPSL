function gfcheckfilter2(f0,theta,gamma,eta,n,pt,pf)
%GFCHECKFILTER2 Check 2-d filter parameters.
%
%   GFCHECKFILTER2(F0,THETA,GAMMA,ETA,N,PT,PF)  Checks the
%   constraints of the discrete Gabor filter for given parameters
%   and prints out warning or error messages.
%
%     F0    - Central frequency
%     THETA - Orientation
%     GAMMA - Width parallel to wave
%     ETA   - Orthogonal width
%     N     - Size of the filter
%     PT    - Spatial domain percent factor
%     PF   - Frequency domain Percent factor, (major and minor axes)
%
%   Examples
%
%     gfcheckfilter2(1/64, pi/2, 1, 1, 64, 0.998, 0.998);
%     gfcheckfilter2(1/64, pi/2, 1, 1, 64, 0.998, [0.998 0.95]);
%
%   See also GFCREATEFILTER2, GFCREATEFILTERF2.
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

% Check filter size parameter
if length(n)>1,
  nx=n(1);
  ny=n(2);
else
  nx=n;
  ny=n;
end;

% Check if different values for major and minor axes of Frequency
% domain Gaussian envelope
if length(pf)>1,
  pf1 = pf(1);
  pf2 = pf(2);
else
  pf1 = pf;
  pf2 = pf;
end;

% Set checking values
alpha = f0/gamma;
beta = f0/eta;
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
% Lasketaan 'leveydet' aallon suunnassa ja aaltoa vastaan kohtisuoraan
lx=max(abs([cos(theta)*nx sin(theta)*ny]));
ly=max(abs([sin(theta)*nx cos(theta)*ny]));
	   
% Filtterin symmetrisen osan tulee sis‰lt‰‰ pt prosenttia 
fpt = abs(erf(alpha*floor((lx-1)/2))*erf(beta*floor((ly-1)/2)));
if (fpt < pt)
  warning(['Spatial filter size may be too small. '...
	   ' Requested minimum spatial envelope size is '...
	   num2str(pt*100) ' percent and current size is '...
	   num2str(100*fpt)]);
end;

%
% Checking frequency constraints

% marjor axis constraints
fpf1 = erf(pi/alpha*f0);
if (fpf1 < pf1)
  warning(['Filter envelope insufficiently located along the major axis in the frequency domain. '...
	   ' Requested minimum envelope area inside domain is '...
	   num2str(100*pf1) ' percent and currently area is ' ...
	   num2str(100*fpf1)]);
%  warning(['Area of filter envelope along the major axis insufficient' ...
%	   ' in frequency domain']); 
end;

% minor axis constraints
fpf2 = erf(pi/(beta)*1/2);
if (fpf2 < pf2)
  warning(['Filter envelope insufficiently located along the minor axis in the frequency domain. '...
	   ' Requested minimum envelope area inside domain is '...
	   num2str(100*pf2) ' percent and currently area is ' ...
	   num2str(100*fpf2)]);
%  warning(['Area of filter envelope along the minor axis insufficient' ...
%	   ' in frequency domain']); 
end;












