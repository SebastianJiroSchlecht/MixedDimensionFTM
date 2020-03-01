function [ftm, state] = createModel(string, T, x)
%% Eigenvalues 
% Number of complex pairs 
ftm.Nu = 20; 
ftm.nu = 1:ftm.Nu; 

% Number of individual eigenvalues 
ftm.Mu = 2*ftm.Nu;
ftm.mu = 1:ftm.Mu;

% calculate complex pairs of eigenvalues s_nu = sigma_nu \pm j*omega_nu 
% i.e., only s_nu = sigma_nu + j*omega_nu is calculated 

[ftm.snu, ftm.gnu] = fct_eigenvalues(string,ftm);

% sort eigenvalues --> Normally not necessary for this case
% [ftm.snu, ind] = sort(ftm.snu(:),'descend','ComparisonMethod','real');

% create complete vector of individual eigenvalues s_mu 
ftm.smu = [ftm.snu(:); conj(ftm.snu(:))];
ftm.gm = [ftm.gnu(:); ftm.gnu(:)];

% ftm.smu= [ftm.snu(1); conj(ftm.snu(1))];
% ftm.gm = [ftm.gnu(1); ftm.gnu(1)];
% ftm.Mu = 2;
% ftm.mu = 1:ftm.Mu;

%% Eigenfunctions, Scaling 
ftm.x = x;
[ftm.kprim, ftm.kadj] = fct_eigenfunctions(string,ftm,ftm.x);
ftm.nmu = fct_nmu(ftm,string);

%% state space description

state.As = diag(ftm.smu);
state.Az = expm(state.As*T);

state.C = ftm.kprim./ftm.nmu;

end