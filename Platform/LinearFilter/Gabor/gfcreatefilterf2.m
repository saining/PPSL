%GFCREATEFILTERF2 Create normalized 2-D Gabor filter in the frequency domain.
%
%   [G] = GFCREATEFILTERF2(F0,THETA,GAMMA,ETA,N,...) creates a
%   two-dimensional normalized Gabor filter G with central
%   frequency F0, orientation THETA, normalized width GAMMA along
%   the wave orientation, normalized width ETA orthogonal to wave
%   orientation,  and size N. Also, a two element vector N = [NX
%   NY] can be used to specify the size.
%
%   G = GFCREATEFILTERF2(...,'PF',PF) determines that at least
%   P percent of the Gaussian envelope of the filter must be
%   included in the filter in frequency domain. For default,
%   PF=0.998. 
%
%   G = GFCREATEFILTERF2(...,'PT',PT) determines that at least
%   P percent of the Gaussian envelope of the filter must be
%   included in the filter in spatial domain. For default,
%   PT=0.998. 
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
%   $Name: V_0_4 $ $Revision: 1.6 $  $Date: 2003/02/23 16:27:44 $
%
function [g]=gfcreatefilterf2(f0, theta, gamma, eta, N,varargin)

%
% Setting default values
alpha = f0/gamma;
beta = f0/eta;
PT = 0.998;
PF = 0.998;

%
% Parameter parsing
if mod(length(varargin),2)>0,
  error('Each parameter must be given a value.');
end;

currentarg = 1;
while (length(varargin) > currentarg)
  [param,value]=deal(varargin{currentarg:currentarg+1});
  switch lower(param)
   case 'pt'
    PT = value;
   case 'pf'
    PF = value;
   otherwise
    error(['Unknown parameter ''' param '''.']);
  end;
  currentarg=currentarg+2;
end;

% filter size
if length(N)>1,
  Nx=N(1);
  Ny=N(2);
else
  Nx=N;
  Ny=N;
end;

% Check filter constraints
gfcheckfilter2(f0,theta,gamma,eta,N,PT,PF);

% Check if save file exists and load it
if (isunix)
     [status userName] = unix('whoami');
     if (size(userName,2) > 1)
        useTempFiles = 1;
        userName = userName(1,1:end-1);% remove line change
        temporarySaveFileName = ...
          fullfile(tempdir,['gf-' userName '-' ...
				  num2str(f0)  '-' num2str(theta) ...
				  '-' num2str(gamma) '-' num2str(eta) '-' num2str(Nx) ...
				  '-' num2str(Ny) '-' num2str(PT) '-' num2str(PF) '.mat']);
     else
	useTempFiles = 0;
     end;
else
     [status userName] = unix('echo %USERNAME%');
     if (size(userName,2) > 1)
        useTempFiles = 1;
        userName = userName(1,1:end-1);% remove line change
        temporarySaveFileName = ...
          fullfile(tempdir,['gf-' userName '-' ...
				  num2str(f0)  '-' num2str(theta) ...
				  '-' num2str(gamma) '-' num2str(eta) '-' num2str(Nx) ...
				  '-' num2str(Ny) '-' num2str(PT) '-' num2str(PF) '.mat'])
     else
	useTempFiles = 0;
     end;
end;

% THIS WAS OLD WAY BUT IT DIDNT WORK IN WINDOWS AND SUFFERED USMASKS BETWEEN
% DIFFERENT USERS IN THE SAME SYSTEM
%temporarySaveFileName = fullfile
%temporarySaveFileName = ['/tmp/gffilter-' num2str(f0)  '-' num2str(theta) ...
%		    '-' num2str(gamma) '-' num2str(eta) '-' num2str(Nx) ...
%		    '-' num2str(Ny) '-' num2str(PT) '-' num2str(PF) '.mat']

if (useTempFiles==1 & exist(temporarySaveFileName) == 2)
  load(temporarySaveFileName);
else
    g = zeros(Ny,Nx);
  
  % SOLUTION 1: easy to understand, but may need whole lotta memory
  nx = -Nx:1:Nx;
  ny = -Ny:1:Ny;
  u = nx/Nx; % frequencies that bank contains
  v = ny/Ny;
  [U,V]=meshgrid(u,v);
  gf = exp(-pi^2*( (U*sin(theta)-V*cos(theta)).^2/beta^2 + ...
		   (U*cos(theta)+V*sin(theta)-f0).^2/alpha^2 ));
  
  % Calculating the filter using aliasing
  g = g+gf(1:Ny,1:Nx); % A_1
  g = g+gf(1:Ny,(Nx+1):(2*Nx)); % A_2
  g = g+gf((Ny+1):(2*Ny),1:Nx); % A_3
  g = g+gf((Ny+1):(2*Ny),(Nx+1):(2*Nx)); % A_4
  
  if (useTempFiles) % save this filter
    save(temporarySaveFileName, 'g');
  end;
end;
  

  
  





