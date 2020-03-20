function matlab2tikz_sjs(filename, varargin)
% Sebastian J. Schlecht, Friday, 5. April 2019
%
% some useful extraAxisOptions
% 'legend style={legend columns=3}'
% 'ytick distance=35'
% 'minor tick num=1'
% 'yticklabel style={/pgf/number format/fixed,/pgf/number
% format/precision=5}, scaled y ticks=false'
%



%% parser
p = inputParser;
addParameter(p,'type','standardSingleColumn',@ischar);
addParameter(p,'extraAxisOptions',{},@iscell);
addParameter(p,'height','4.6cm',@ischar);
addParameter(p,'width','8.8cm',@ischar);
parse(p,varargin{:});

extraAxisOptions = p.Results.extraAxisOptions;
type = p.Results.type;
height = p.Results.height;
width = p.Results.width;

%% create
switch type
    case 'standardSingleColumn'
        matlab2tikz(filename,'height', '\figureheight', 'width', '\figurewidth',...
            'extraAxisOptions',{'ylabel near ticks','xlabel near ticks',...
            'ylabel style={font=\small\fontfamily{ptm}\selectfont}',...
            'xlabel style={font=\small\fontfamily{ptm}\selectfont}',...
            'legend style={font=\small\fontfamily{ptm}\selectfont},',...
            'ticklabel style={font=\small\fontfamily{ptm}\selectfont}',...
            extraAxisOptions{:} ...
            },...
            'parseStrings',false,'standalone', true, ...
            'height', height, 'width', width)
    otherwise
        matlab2tikz(filename,'standalone',true);
end


% run pdflatex on generated file
% setenv('PATH', [getenv('PATH') ':/usr/local/texlive/2019/bin/x86_64-darwin']);
plotviatikztopdf(filename)
