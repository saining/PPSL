%GFFINDFUNDAMENTALFREQS Find fundamental frequencies of an image.
%
%   [FF O V I] =
%        GFFINDFUNDAMENTALFREQS(IMG, X0, Y0, F0, THETA, GAMMA, ETA)
%   finds fundamental frequencies of the image IMG at spatial
%   location (X0,Y0). Frequencies F0 (1xM) and orientations THETA
%   (1xN) will be under inspection for normalized Gabor functions
%   for sharpness values GAMMA and ETA. Function returns the
%   fundmental frequencies FF, at every orientation O (=THETA),
%   normalized values V of Gabor filter responses r_img(x0,y0) and
%   indeces I to frequencies F0(I) at every angle O.
%
%   Examples
%
%   See also GFCREATEINFORMATIONDIAGRAM2.
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
function [fundFreqs,orients,vals,indeces] = ...
    gffindfundamentalfreqs(img_, x0_, y0_, f0_, theta_, gamma_, eta_); 

[resps freqs orients] = gfcreateinformationdiagram2(img_, f0_, theta_, ...
			  gamma_, eta_, x0_, y0_);

% return everything as row vectors
[vals indeces] = max(abs(resps));
fundFreqs = diag(diag(f0_(indeces)))';
orients = diag(diag(theta_))';
