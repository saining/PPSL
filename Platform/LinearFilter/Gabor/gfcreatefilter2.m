function [g]=gfcreatefilter2(f0,theta,gamma,eta,n,varargin)
% GFCREATEFILTER2 Create normalized 2-D Gabor filter in the spatial domain.
%
%   G = GFCREATEFILTER2(F0,THETA,GAMMA,ETA,N,...) creates a 
%   two-dimensional normalized Gabor filter G with frequency F0, 
%   orientation THETA, normalized width GAMMA along the wave,
%   normalized width ETA orthogonal to the wave, and size N.
%   If N is a scalar, G will have equal number of rows and
%   columns. Also a two element vector N=[NX NY] can be used to
%   specify the size.  
%
%   G = GFCREATEFILTER2(...,'PF',PF) determines that at least
%   P percent of the Gaussian envelope of the filter must be
%   included in the filter in frequency domain. For default,
%   PF=0.998. 
%
%   G = GFCREATEFILTER2(...,'PT',PT) determines that at least
%   P percent of the Gaussian envelope of the filter must be
%   included in the filter in spatial domain. For default,
%   PT=0.998. 
%
%   Examples
%
%   See also GFCREATEFILTERF2, GFCHECKFILTER2, GFCREATEFILTERF.
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
%   $Name: V_0_4 $ $Revision: 1.9 $  $Date: 2003/03/03 10:51:17 $
%
pt=0.998; % corresponds approximately to (1-1/512)
pf=0.998;

if mod(length(varargin),2)>0,
  error('Each parameter must be given a value.');
end;

currentarg=1;
while length(varargin)>currentarg,

  [param,value]=deal(varargin{currentarg:currentarg+1});

  switch lower(param)
   case 'pt'
    pt=value;
   otherwise
    error(['Unknown parameter ''' param '''.']);
  end;
  
  currentarg=currentarg+2;
end;

gfcheckfilter2(f0,theta,gamma,eta,n,pt,pf);

alpha=f0/gamma;
beta=f0/eta;

if length(n)>1,
  nx=n(1);
  ny=n(2);
else
  nx=n;
  ny=n;
end;

% Parittomalla pituudella indeksit -(n-1)/2:(n-1)/2
% Parillisella -(n/2):(n/2-1)
% Esim. 9 -> -4:4, 8 -> -4:3
if mod(nx,2)>0,
  tx=-((nx-1)/2):(nx-1)/2;
else
  tx=-(nx/2):(nx/2-1);
end;

if mod(ny,2)>0,
  ty=-((ny-1)/2):(ny-1)/2;
else
  ty=-(ny/2):(ny/2-1);
end;

[X,Y]=meshgrid(tx,ty);

g=abs(alpha*beta)/pi*exp(-alpha^2*(X*cos(theta)+Y*sin(theta)).^2-...
		    beta^2*(-X*sin(theta)+Y*cos(theta)).^2 +...
		    j*2*pi*f0*(X*cos(theta)+Y*sin(theta)));



