% Gabor Features in Signal and Image Processing Toolbox.
% Version 0.1 (R12) 01-Jan-2002
%
% 1-D Gabor filtering
%   gfcreatefilter             - Create normalized 1-D Gabor filter in the time domain.
%   gfcreatefilterf            - Create normalized 1-D Gabor filter in the frequency domain.
%   gfcheckfilter              - Check filter parameters.
%   gfplotfiltersf             - Plot 1-D normalized Gabor filters in the frequency domain.
%
% 2-D Gabor filtering basic functionality
%   gfcreatefilter2             - Create normalized 2-D Gabor filter in the spatial domain.
%   gfcreatefilterf2            - Create normalized 2-D Gabor filter in the frequency domain.
%   gfcheckfilter2              - Check filter parameters.
%   gfrespf2                    - 2-D filter response using frequency domain filters.
%   gfequalorientations         - Equally spaced orientations.
%   gfnormrespf2                - 2-D filter response using frequency domain filters (REPLACED).
%
% 2-D Gabor features special feature manipulation
%   gfcreateinformationdiagram2 - Information diagram of a 2-D signal
%   gffindfundamentalfreqs      - Find fundamental frequencies of an image
%   
% Demos
%   gfdemo01                  - Demonstrate 1-D Gabor functinality.
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
%   The software package is free software; you can redistribute it
%   and/or modify it under terms of GNU General Public License as
%   published by the Free Software Foundation; either version 2 of
%   the license, or any later version. For more details see licenses
%   at http://www.gnu.org
%
%   The software package is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%   See the GNU General Public License for more details.
%
%   As stated in the GNU General Public License it is not possible to
%   include this software library or even parts of it in a proprietary
%   program wihtout written permission from the owners of the copyright.
%   If you wish to obtain such permission, you can reach us by mail:
%
%      Gabor Features in Signal and Image Processing Research Group
%      Department of Information Processing
%      Lappeenranta University of Technology
%      P.O. Box 20 FIN-53851 Lappeenranta
%      FINLAND
%
%  and by e-mail:
%      
%      Joni.Kamarainen@lut.fi
%      Ville.Kyrki@lut.fi
%
%  Please, if you find any bugs contact authors.
%
%   $Name: V_0_4 $ $Revision: 1.7 $  $Date: 2003/02/23 16:27:44 $
%



