%=====================================================================
% (v1b)
%    
%=====================================================================

function [OUTPUT,err] = GenProj_CaTpi_v1d(INPUT)

Status2('done','Generate CaTpi Trajectory',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
RADEV = INPUT.RADEV;
TPIT = INPUT.TPIT;
DESOL = INPUT.DESOL;
PSMP = INPUT.PSMP;
TST = INPUT.TST;
FinalSolution = INPUT.FinalSolution;
clear INPUT;
OUTPUT = struct();

%---------------------------------------------
% Specify Common Variables
%---------------------------------------------
if isfield(TST,'DoAllStraight')
    DoAllStraight = TST.DoAllStraight;
else
    DoAllStraight = 0;
end

%---------------------------------------------
% Retrospective TPI comparison
%---------------------------------------------
RetroTPI = 0;
if isfield(TPIT,'RetroTPI')
    RetroTPI = TPIT.RetroTPI;
end

%---------------------------------------------
% Specify Common Variables
%---------------------------------------------
p = PROJdgn.p;
tro = PROJdgn.tro;

%---------------------------------------------
% Setup Differection Equation Solver
%---------------------------------------------
if RetroTPI == 0
    options = odeset('RelTol',2.5e-14,'AbsTol',[1e-25,1e-25]);
else
    options = odeset('RelTol',2.5e-14,'AbsTol',[1e-20,1e-20]);
end
deradsolinfunc = str2func(['@(r,p)' RADEV.deradsolinfunc]);
deradsolinfunc = @(r) deradsolinfunc(r,p);
deradsoloutfunc = str2func(['@(r,p)' RADEV.deradsoloutfunc]);
deradsoloutfunc = @(r) deradsoloutfunc(r,p);

tau1 = DESOL.tau1;
tau2 = DESOL.tau2;
phi0 = PSMP.phi;
theta0 = PSMP.theta;

if RetroTPI == 0
    len = DESOL.len;
    KSA = zeros(length(phi0),len,3);
    kArrX = zeros(length(phi0),len);
    kArrY = zeros(length(phi0),len);
    kArrZ = zeros(length(phi0),len);
else
    len = length((p:-0.001:0.001)) + length(DESOL.tau2);
    KSA = zeros(length(phi0),len,3);
    kArrX = zeros(length(phi0),len);
    kArrY = zeros(length(phi0),len);
    kArrZ = zeros(length(phi0),len);
end

%---------------------------------------------
% Setup
%---------------------------------------------
INPUT.TPIT = TPIT;
INPUT.deradsolfunc = deradsolinfunc;
defuncIn0 = @(t,y,phi) TPIT.tpiin(t,y,phi,INPUT); 
INPUT.deradsolfunc = deradsoloutfunc;
defuncOut0 = @(t,y,phi) TPIT.tpiout(t,y,phi,INPUT); 
   
%---------------------------------------------
% Solve
%---------------------------------------------
haderror = 0;
divs = 200;
for m = 1:ceil(length(phi0)/divs)
    if m*divs < length(phi0)
        narray = (m-1)*divs+1:m*divs;
    else
        narray = (m-1)*divs+1:length(phi0);
    end
    if ceil(length(phi0)/divs) > 1
        Status2('busy',['Generate Trajectory Number: ',num2str(narray(1))],2);
    else
        Status2('busy','Generate Trajectories',2);
    end
    for n = narray 
        %---------------------------------------------
        % Fix for phi == 0
        %---------------------------------------------
        if phi0(n) == 0                     
            phi = pi/2;                     % anything but zero
        else
            phi = phi0(n);                      
        end
        
        %---------------------------------------------
        % Inside
        %---------------------------------------------
        if RetroTPI
            r1 = (p:-0.001:0.001);
            theta1 = zeros(size(r1));
        else
            defuncIn = @(t,y) defuncIn0(t,y,phi);
            [x,Y] = ode113(defuncIn,tau1,[p,theta0(n)],options); 
            r1 = Y(:,1).';  
            theta1 = Y(:,2).';
        end

        %---------------------------------------------
        % Outside
        %---------------------------------------------
        defuncOut = @(t,y) defuncOut0(t,y,phi);
        [x,Y] = ode113(defuncOut,tau2,[p,theta0(n)],options);
        r2 = Y(2:length(tau2),1).';
        theta2 = Y(2:length(tau2),2).';

        %---------------------------------------------
        % Join
        %---------------------------------------------
        r = real([0 flip(r1,2) r2]); 
        if phi0(n) == 0     
            theta = zeros(1,len);
            phi = phi0(n);
        else
            theta = real([0 flip(theta1,2) theta2]);
        end
        
        %---------------------------------------------
        % 'DoAllStraight' test
        %---------------------------------------------
        if DoAllStraight == 1 && FinalSolution == 1
            if phi0(n) ~= 0
                theta = theta0(n) * ones(1,length(tau1)+length(tau2));
            end
        end
        
        %---------------------------------------------
        % Save
        %---------------------------------------------        
        kArrX(n,:) = r.*sin(phi).*cos(theta);                              
        kArrY(n,:) = r.*sin(phi).*sin(theta);
        kArrZ(n,:) = r.*cos(phi); 
    end
    if ceil(length(phi0)/divs) > 1
        Status2('busy',['Generate Trajectory Number: ',num2str(narray(end))],2);
    end
end

if sum(haderror) > 0
    err.flag = 1;
    err.msg = 'Negative DE Solution Problem. Adjust DE solution timing';
end

%------------------------------------------
% Consolidate
%------------------------------------------    
KSA(:,:,1) = kArrX;
KSA(:,:,2) = kArrY;
KSA(:,:,3) = kArrZ;

%------------------------------------------
% Calculate Real Timings
%------------------------------------------
if RetroTPI == 0
    tautot = (DESOL.plin)+[-(DESOL.plin) flip(tau1,2) tau2(2:length(tau2))];      % (plin) for negative differential solution - from [1-40] thesis 
    projlen0 = DESOL.plin+DESOL.plout;
else
    tautot = [(0:0.001:p) p+tau2(2:length(tau2))]
    projlen0 = tautot(end);
end
    
TArr = (tautot/projlen0)*tro;

%------------------------------------------
% Return
%------------------------------------------    
OUTPUT.projlen0 = projlen0;
OUTPUT.T = TArr;
OUTPUT.KSA = KSA;
    
Status2('done','',2);
Status2('done','',3);



