%=========================================================
% 
%=========================================================

function [default] = ConstEvol_CaTpi_v1k_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GaccStart';
default{m,1}.entrystr = '5000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GvelStart';
default{m,1}.entrystr = '180';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'pFracDecel';
default{m,1}.entrystr = '0.13';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GaccTransition';
default{m,1}.entrystr = '5000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GvelReturn';
default{m,1}.entrystr = '180';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ReturnTwk1';
default{m,1}.entrystr = '0.9997';
