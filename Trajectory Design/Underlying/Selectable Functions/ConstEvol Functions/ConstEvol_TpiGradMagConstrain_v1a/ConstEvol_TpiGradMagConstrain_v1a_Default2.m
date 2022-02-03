%=========================================================
% 
%=========================================================

function [default] = ConstEvol_TpiGradMagConstrain_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GaccStart';
default{m,1}.entrystr = '5000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GvelStart';
default{m,1}.entrystr = '160';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GmagInit';
default{m,1}.entrystr = '5.5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GaccTransition';
default{m,1}.entrystr = '2000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GvelMatch';
default{m,1}.entrystr = '23';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'pFracMatchStart';
default{m,1}.entrystr = '0.96';