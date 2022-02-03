%==================================================
% 
%==================================================

function [CACC,err] = ConstEvol_TpiGradMagConstrain_v1a_Func(CACC,INPUT)

Status2('busy','Constrain Trajectory Evolution',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input / Build Class
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
TST = INPUT.TST;
tArr = INPUT.TArr.';
kArr = INPUT.kArr*PROJdgn.kmax;
clear INPUT

%---------------------------------------------
% Build TEVO Class
%---------------------------------------------
GradSlewMax = 195;
GradAccMax = 8000;
TEVO = ConstEvol_TpiGradMagConstrain_v1a_obj(kArr,tArr,GradSlewMax,GradAccMax,PROJdgn,PROJimp,TST);
TEVO.PlotEvolutionSetup();

%---------------------------------------------
% Test Deflection Angle
%---------------------------------------------
MaxAngle = 5;       % degree
if(not(TEVO.TestDeflectionAngle(MaxAngle)))
    TEVO.PlotDeflectionAngle();
    err.flag = 1;
    err.msg = 'Trajectory must be solved more finely (deflection angle)';
    return
end

%---------------------------------------------
% First Step
%---------------------------------------------
%JrkFirst = CACC.gaccstart*PROJimp.gamma*1.5;
JrkFirst = CACC.gaccstart*PROJimp.gamma;
tSeg = TEVO.SolveAccRampSpecifyJrk(JrkFirst);
TEVO.BuildTimeArray(tSeg);
TEVO.MoveNext();

%---------------------------------------------
% Ramp up acceleration
%---------------------------------------------
JrkStart = CACC.gaccstart*PROJimp.gamma;
AccStart = CACC.gvelstart*PROJimp.gamma;
while true
    tSeg = TEVO.SolveAccRampSpecifyJrk(JrkStart);
    if TEVO.TestGreaterSpecifyAcc(AccStart)
        break
    end
    TEVO.BuildTimeArray(tSeg);
    TEVO.PlotEvolution(100);
    TEVO.MoveNext();
end

%---------------------------------------------
% Accelerate to Mag
%---------------------------------------------
Loc = TEVO.GetLoc();
VelMagInit = CACC.gmaginit*PROJimp.gamma; 
VelMagTrans = VelMagInit * 0.8;
while true
    
    %---------------------------------------------
    % Maintian acceleration
    %---------------------------------------------
    while true
        tSeg = TEVO.SolveSpecifyAcc(AccStart); 
        if TEVO.TestGreaterSpecifyVel(VelMagTrans)
            break
        end
        TEVO.BuildTimeArray(tSeg);
        TEVO.PlotEvolution(100);
        TEVO.MoveNext();
    end

    %---------------------------------------------
    % Ramp to deceleration
    %---------------------------------------------
    JrkTransition = CACC.gaccstart*PROJimp.gamma;
    while true
        tSeg = TEVO.SolveAccRampSpecifyJrk(-JrkTransition); 
        if TEVO.TestLessSpecifyAcc(0)
            TEVO.MoveBack();
            TEVO.PlotEvolution(1);
            TEVO.MoveNext();
            break
        end
        TEVO.BuildTimeArray(tSeg);
        TEVO.PlotEvolution(100);
        TEVO.MoveNext();
    end
    
    %---------------------------------------------
    % Test
    %---------------------------------------------
    if TEVO.TestGreaterSpecifyVel(VelMagInit)
        VelMagTrans = VelMagTrans * 0.99;
        TEVO.SetLoc(Loc);
    else
        TEVO.PlotSegmentMarker;
        TEVO.MoveBack();
        TEVO.PlotEvolution(1);
        TEVO.MoveNext();
        break
    end   
end

%---------------------------------------------
% Maintian Magnitude
%---------------------------------------------
MatchStart = CACC.pfracmatchstart * PROJdgn.p;
while true
    tSeg = TEVO.SolveSpecifyAcc(0.1); 
    if TEVO.TestGreaterRelRad(MatchStart)
        break
    end
    TEVO.BuildTimeArray(tSeg);
    TEVO.PlotEvolution(100);
    TEVO.MoveNext();
    if rem(TEVO.GetLoc(),500) == 0
        test = 0;
    end
end

%---------------------------------------------
% Ramp to deceleration
%---------------------------------------------
JrkTransition = CACC.gacctransition*PROJimp.gamma;
AccReturn = CACC.gvelmatch*PROJimp.gamma;
while true
    tSeg = TEVO.SolveAccRampSpecifyJrk(-JrkTransition); 
    if TEVO.TestLessSpecifyAcc(-AccReturn)
        TEVO.PlotSegmentMarker;
        break
    end
    TEVO.BuildTimeArray(tSeg);
    TEVO.PlotEvolution(100);
    TEVO.MoveNext();
end

%---------------------------------------------
% Test
%---------------------------------------------
if TEVO.TestLessVel0Seg()
    while true
        tSeg = TEVO.SolveSpecifyAcc(-AccReturn); 
        if TEVO.TestGreaterVel0Seg()
            break
        end
        ErrorAtVel = 10;
        if TEVO.TestLessSpecifyVel(ErrorAtVel)
            TEVO.MoveBack();
            TEVO.PlotEvolution(100);
            err.flag = 1;
            err.msg = 'Fix Evolution Design';
            return
        end
        TEVO.BuildTimeArray(tSeg);
        TEVO.PlotEvolution(100);
        TEVO.MoveNext();
    end    
end

CACC.returntwk = 1.0;

%---------------------------------------------
% Finish
%---------------------------------------------
regfunc = str2func('ReturnTwk2Regression');
Loc = TEVO.GetLoc();
func = @(Twk) regfunc(TEVO,PROJdgn,Loc,AccReturn,Twk);
options = optimoptions(@lsqnonlin,'FiniteDifferenceStepSize',1e-6);
lb = 0.95;
ub = 1.05;
Twk0 = CACC.returntwk;
CACC.returntwk2 = lsqnonlin(func,Twk0,lb,ub,options);

%TEVO.PlotEvolutionFullSetup();
%TEVO.PlotEvolutionFull();
TEVO.FixTiming();
TEVO.PlotEvolutionEnd();
CACC.TArr = TEVO.tSamp;
%---
CACC.Vel0 = TEVO.Vel0;
CACC.Vel = TEVO.Vel;
CACC.Acc0 = TEVO.Acc0;
CACC.Acc = TEVO.Acc;
CACC.Jrk0 = TEVO.Jrk0;
CACC.Jrk = TEVO.Jrk;
CACC.tArr = TEVO.tArr;
CACC.kMagArr = TEVO.kMagArr;
CACC.tSamp = TEVO.tSamp;
CACC.DefAngle = TEVO.DefAngle;

%----------------------------------------------------
% Figure
%----------------------------------------------------
CACC.Figure(1).Name = 'ConstEvol Characteristics';
CACC.Figure(1).Type = 'Graph';
CACC.Figure(1).hFig = TEVO.PlotEvFigHand;
CACC.Figure(1).hAx = gca;

Status2('done','',3);
end

%==================================================
% ReturnTwk2Regression
%==================================================
function [Rem] = ReturnTwk2Regression(TEVO,PROJdgn,Loc,AccReturn0,ReturnTwk2)

    TEVO.SetLoc(Loc); 
    AccReturn = AccReturn0;
    while true
        tSeg = TEVO.SolveSpecifyAcc(-AccReturn); 
        if TEVO.TestLessAcc0Seg()
            break
        end
        TEVO.BuildTimeArray(tSeg);
        TEVO.PlotEvolution(100);
        TEVO.MoveNext();
        AccReturn = AccReturn^ReturnTwk2;
    end
    while true
        tSeg = TEVO.SolveAccAtAcc0Seg(); 
        TEVO.BuildTimeArray(tSeg);
        TEVO.PlotEvolution(250);
        TEVO.MoveNext();
        if TEVO.TestEnd()
            TEVO.MoveBack();
            break
        end
    end
    ReturnTwk2 = ReturnTwk2
    Tatkmax = TEVO.Tatkmax()       
    Rem = Tatkmax - PROJdgn.tro
end

