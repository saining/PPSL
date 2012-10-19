% GFEQUALORIENTATIONS Equally spaced orientations.
%
%     O = GFEQUALORIENTATIONS(N) returns the orientation angles
%     (theta) O for N equally spaced directions
%
%     O(k) = (k-1)/N 
%
%   Examples
%
%   See also GFCREATEFILTER2, GFCHECKFILTER2, GFCREATEFILTERF.
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
function [o]=gfequalorientations(n)

orientationTicks = [0:n-1];
o = orientationTicks*pi/n;
