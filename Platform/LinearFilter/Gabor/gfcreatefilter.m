function [g]=gfcreatefilter(f0,gamma,n,varargin)
% GFCREATEFILTER Create normalized 1-D Gabor filter in time domain.
%
%     G = GFCREATEFILTER(F0,GAMMA,N,...) creates a normalized Gabor
%     filter G with frequency F0, normalized width GAMMA, and
%     length N. 
%
%     G = GFCREATEFILTER(...,'pt',PT) determines that at least
%     PT percent of the Gaussian envelope of the filter must be
%     included in the filter in spatial domain. For default, 
%     P=0.998.
%
%     G = GFCREATEFILTER(...,'pf',PF) determines that at least
%     PF percent of the Gaussian envelope of the filter must be
%     included in the filter in frequency domain. For default,
%     PF=0.998. 
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
%   $Name: V_0_4 $ $Revision: 1.7 $  $Date: 2003/03/03 10:51:17 $
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
   case 'pf'
    pf=value;
   otherwise
    error(['Unknown parameter ''' param '''.']);
  end;
  
  currentarg=currentarg+2;
end;

gfcheckfilter(f0,gamma,n,pt,pf);

alpha=f0/gamma;

% Parittomalla pituudella indeksit -(n-1)/2:(n-1)/2
% Parillisella -(n/2):(n/2-1)
% Esim. 9 -> -4:4, 8 -> -4:3
% Filttering nollakohdan indeksi siis parillisella n/2+1
% parittomalla (n+1)/2
if mod(n,2)>0,
  t=-((n-1)/2):(n-1)/2;
else
  t=-(n/2):(n/2-1);
end;

g=abs(alpha)/sqrt(pi)*exp(-alpha^2*t.^2+j*2*pi*f0*t);



