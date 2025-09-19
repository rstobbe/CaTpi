%=========================================================
% 
%=========================================================

function [default] = ImpMeth_CaTpi_v1d_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    radevpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\General\RadSolEv Functions\TPI\'];
    DEsoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\General\DeSolTim Functions\TPI\']; 
    accconstpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\General\ConstEvol Functions\TPI\']; 
    TrajSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajSamp Functions\'];
    TrajEndpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\TrajEnd Functions\']; 
    SYSRESPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\SysResp SubFunctions\']; 
    ORNTpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\Orient Functions\'];
    KSMPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\1 ImCon Related\kSamp Functions\'];     
elseif strcmp(filesep,'/')
end
radevfunc = 'RadSolEv_TpiForConstEvol_v1a';
DEsoltimfunc = 'DeSolTim_TpiManual_v1f';
accconstfunc = 'ConstEvol_CaTpi_v1k';
TrajSampfunc = 'TrajSamp_SiemensStandard_v3i';
TrajEndfunc = 'TrajEnd_StandardSpoil_v1e';
SYSRESPfunc = 'SysResp_FromFileWithComp_v1h'; 
ORNTfunc = 'Orient_TpiFlexible_v1d'; 
KSMPfunc = 'kSamp_Option1_v1b';

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ElipAdd';
default{m,1}.entrystr = 'BeforeConst';
default{m,1}.options = {'AfterConst','BeforeConst'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Orientfunc';
default{m,1}.entrystr = ORNTfunc;
default{m,1}.searchpath = ORNTpath;
default{m,1}.path = [ORNTpath,ORNTfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RadSolEvfunc';
default{m,1}.entrystr = radevfunc;
default{m,1}.searchpath = radevpath;
default{m,1}.path = [radevpath,radevfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DeSolTimfunc';
default{m,1}.entrystr = DEsoltimfunc;
default{m,1}.searchpath = DEsoltimpath;
default{m,1}.path = [DEsoltimpath,DEsoltimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ConstEvolfunc';
default{m,1}.entrystr = accconstfunc;
default{m,1}.searchpath = accconstpath;
default{m,1}.path = [accconstpath,accconstfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajEndfunc';
default{m,1}.entrystr = TrajEndfunc;
default{m,1}.searchpath = TrajEndpath;
default{m,1}.path = [TrajEndpath,TrajEndfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SysRespfunc';
default{m,1}.entrystr = SYSRESPfunc;
default{m,1}.searchpath = SYSRESPpath;
default{m,1}.path = [SYSRESPpath,SYSRESPfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajSampfunc';
default{m,1}.entrystr = TrajSampfunc;
default{m,1}.searchpath = TrajSamppath;
default{m,1}.path = [TrajSamppath,TrajSampfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'kSampfunc';
default{m,1}.entrystr = KSMPfunc;
default{m,1}.searchpath = KSMPpath;
default{m,1}.path = [KSMPpath,KSMPfunc];
