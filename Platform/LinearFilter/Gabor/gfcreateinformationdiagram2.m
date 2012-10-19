%GFCREATEINFORMATIONDIAGRAM2 Information diagram of 2-D signal
%   
%   [RESPS FREQS ORIENTS] =
%        GFCREATEINFORMATIONDIAGRAM2(IMG, F0, THETA, GAMMA, ETA, x0, y0)
%   Creates an information diagram for 2-D signal IMG at locations
%   X0, Y0, using frequencies F0 (diagram Y-axis), orientations
%   THETA (x-axis), and sharpness values GAMMA, ETA. Function
%   return the MxN diagram matrix RESPS, Mx1 vector of frequencies,
%   1xN vector of orientations.
%
%   Examples
%
%   See also GFEQUALORIENTATIONS.
%
% References:
%   [1] Kamarainen, J.-K., Kyrki, V., Kalviainen, H., Gabor
%       Features for Invariant Object Recognition, Research
%       report 79, Department of Information Technology,
%       Lappeenranta University of Technology 
%   [2] Kamarainen, J.-K., Kyrki, V., Kalviainen, H.,
%       Fundamental Frequency Gabor Filters for Object Recognition,
%       Proceedings of ICPR2002 16th Internationa Conference
%       on Pattern Recognition, Vol. 1 pp. 628-631, Quebec City,
%       Canada, 2002.
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
%   $Name: V_0_4 $ $Revision: 1.5 $  $Date: 2003/02/23 16:27:44 $
%
function [resps,freqs,orients] = gfcreateinformationdiagram2(img_, f0_, ...
						  theta_, gamma_, ...
						  eta_, varargin);

freqs = diag(diag(f0_))'; % Mx1
orients = diag(diag(theta_)); % 1xN

if (nargin > 5) % coordinates given 
  x0 = varargin{1};
  y0 = varargin{2};
  resps = zeros(length(freqs), length(orients));
  
  for n = 1:length(orients)
    for m = 1:length(freqs)
      filt = gfcreatefilterf2(freqs(m), orients(n), gamma_, eta_, [size(img_,2) size(img_,1)]);
      resps(m, n) = gfrespf2(filt, img_, x0, y0);
    end;
  end;
else
  resps = zeros(length(freqs), length(orients), size(img_,1), size(img_,2));

  for n = 1:length(orients)
    for m = 1:length(freqs)
      filt = gfcreatefilterf2(freqs(m), orients(n), gamma_, eta_, [size(img_,2) size(img_,1)]);
      resps(m,n,:,:) = gfrespf2(filt, img_);
    end;
  end;
end;









