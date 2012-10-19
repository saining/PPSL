%GFRESPF2 2-D filter response using frequency domain filters.
%
%   [R] = GFRESPF2(GF,S) calculates the response R of
%   Gabor filter GF for the 2-D signal S. GF should be given in
%   frequency space (use GFCREATEFILTERF2) and S in spatial space
%   (gray level image, etc.) If GF is normalized Gabor filter
%   (GFCREATEFILTER2) then the response can be considered as
%   normalized response.
%
%   [R] = GFRESPF2(GF,S,X0,Y0) returns the response at location
%   (Y,X)
%
%     --------> x
%     |
%     |
%     |
%     V y
%
%   Examples
%
%   See also GFCREATEFILTER2.
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
%   $Name: V_0_4 $ $Revision: 1.5 $  $Date: 2003/02/23 16:27:44 $
%
function [r]=gfrespf2(gf_, s_, varargin);

% spatial centered signal -> uncentered frequency spectra 
ffts = fft2(ifftshift(s_));

% response matrix
r = fftshift(ifft2(ffts.*gf_));

% only at some given coordinates
if (nargin > 2) % coordinates given
  x0 = diag(diag(varargin{1}));
  y0 = diag(diag(varargin{2}));
  rn = [];
  for coordInd = 1:length(x0)
    rn = [rn; r(y0(coordInd), x0(coordInd))];
  end;
  r = rn;
end;
