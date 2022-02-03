%=========================================================
% 
%=========================================================

function [default] = CaKaiser_v1d_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Beta';
default{m,1}.entrystr = '3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Slope';
default{m,1}.entrystr = '20';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Shift';
default{m,1}.entrystr = '1.5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Scale';
default{m,1}.entrystr = '0.1';
