%GFNORMRESPF2 2-D filter response using frequency domain filters (REPLACED).
%
%   GFNORMRESPF2 IS REPLACED BY GFRESPF2 AND WILL BE REMOVED IN FUTURE
%   VERSIONS, USE GFRESPF2 INSTEAD.
%
%   [R] = GFNORMRESPF2(N1, N2, GF,S) calculates the normalized
%   response R of Gabor filter GF for the 2-D signal S. GF should
%   be given in frequency space (use GFCREATEFILTERF2) and S in
%   spatial space (gray level image, etc.)
%
%   Examples
%
%   See also GFCREATEFILTER2, GFRESPF2.
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
function [r]=gfnormrespf2(gf_, s_);

% spatial centered signal -> uncentered frequency spectra 
ffts = fft2(ifftshift(s_));

% response matrix
r = fftshift(ifft2(ffts.*gf_));
