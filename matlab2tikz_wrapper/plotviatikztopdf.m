function plotviatikztopdf(filename,varargin)
% Generate a LaTeX file using matlab2tikz and compile
% this directly to PDF with pdflatex, cleaning up temporary
% files after compilation.
%
%    PLOTVIATIKZTOPDF(FILENAME,VARARGIN)
% FILENAME is the name of the generated LaTeX file, with file ending,
% e.g. THING.TEX. VARARGIN is (optional) arguments to matlab2tikz,
% such as definitions of width and height.

% May be required
% setenv('PATH', [getenv('PATH') ':/usr/local/texlive/2019/bin/x86_64-darwin']);
%
% More memory/Add to /usr/local/texlive/2019/texmf.cnf
% 
% main_memory = 7000000 
% extra_mem_top.pdflatex = 200000000
% extra_mem_bot.pdflatex = 400000000


% strip file ending
[filepath,name,ext] = fileparts(filename);

basename = [filepath '/' name];

% run matlab2tikz
% matlab2tikz(filename,'standalone',true,varargin{:})

% run pdflatex on generated file
command = sprintf('pdflatex -aux-directory=%s -output-directory=%s %s ', filepath, filepath, filename);
system(command);

% remove .aux and .log files
if ispc
    system(sprintf('del "%s.aux"',basename));
    system(sprintf('del "%s.log"',basename));
elseif isunix
    system(sprintf('rm %s.aux %s.log',basename,basename));
end