%=========================================================
% 
%=========================================================

function [default] = ConstEvol_TpiCentreAccelerate_v1j_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GaccStart';
default{m,1}.entrystr = '6000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GvelStart';
default{m,1}.entrystr = '165';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FracDecel';
default{m,1}.entrystr = '0.143';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GaccTransition';
default{m,1}.entrystr = '5000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GvelReturn';
default{m,1}.entrystr = '150';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ReturnTwk1';
default{m,1}.entrystr = '0.999675';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TwkLoc2';
default{m,1}.entrystr = '0.15';

