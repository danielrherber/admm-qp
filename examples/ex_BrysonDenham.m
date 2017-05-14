%--------------------------------------------------------------------------
% ex_BrysonDenham.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/admm-qp
%--------------------------------------------------------------------------
clear
clc
close all

testnum = 1;

switch testnum
    case 1
        str = 'bryson-denham-dt1-nt30';
    case 2
        str = 'bryson-denham-dt1-nt1000';
    case 3
        str = 'bryson-denham-dt2-nt15';
    case 4
        str = 'bryson-denham-dt2-nt100';
end
load(str);

% 
opts = [];
opts.method = 'qp-1-over'; 
opts.rho = 'optimal';
% opts.rho = 100000;
opts.displevel = 0;
opts.iterplot = 0; % don't display
opts.tol = 1e-6;
opts.preconditioning = 0;
opts.maxiter = 10000;

% optional parameter structure
p = [];

% solve with quadprog
options = optimoptions('quadprog','OptimalityTolerance',opts.tol,...
    'StepTolerance',opts.tol,'disp','none');
tic
[Xquadprog, Fquadprog] = quadprog(H,f,A,b,Aeq,beq,lb,ub,[],options);
t = toc; disp(['quadprog solving time: ',num2str(t),' s']);

% solve the qp
tic
[Xadmm,Fadmm,p] = qp_admm(H,f,A,b,Aeq,beq,lb,ub,p,opts);
t = toc; disp([' qp_admm solving time: ',num2str(t),' s']);

% plot the solutions
figure
plot(Xquadprog,'.'); hold on
plot(Xadmm,'.'); hold on
legend('quadprog','admm');

figure
plot(Xquadprog-Xadmm,'.'); hold on
legend('difference');