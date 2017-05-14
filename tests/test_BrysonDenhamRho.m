clear
close all
clc

parflag = 0;

if parflag
	if ~isempty(gcp('nocreate'))
        delete(gcp('nocreate'))
    end
    parpool(6)
end

N = 200;
R = logspace(-3,8,N);

% X testnum-1, method-qp-1
% X testnum-1, method-qp-1-over
% X testnum-1, method-qp-2
% testnum-2, method-qp-1
% testnum-2, method-qp-1-over
% testnum-2, method-qp-2
% X testnum-3, method-qp-1
% X testnum-3, method-qp-1-over
% X testnum-3, method-qp-2
% X testnum-4, method-qp-1
% X testnum-4, method-qp-1-over
% X testnum-4, method-qp-2

testnum = 3;

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

opts = [];
opts.method = 'qp-3'; 
opts.displevel = 0;
opts.iterplot = 0; % don't display
opts.tol = 1e-3;
opts.preconditioning = 0;
opts.maxiter = 1e5;

% optional parameter structure
p = [];

% solve the qp

if parflag
    % To request multiple evaluations, use a loop.
	for idx = 1:N
        opts.rho = R(idx);
        o(idx) = parfeval(@qp_admm,3,H,f,A,b,Aeq,beq,lb,ub,p,opts); % Square size determined by idx
	end
    % Collect the results as they become available.
    Fall = nan(N,1);
    Iall = nan(N,1);
    for idx = 1:N
      % fetchNext blocks until next results are available.
      [completedIdx,X,F,p] = fetchNext(o);
      Fall(completedIdx) = F;
      Iall(completedIdx) = p.iter;
      disp(['Got result with index-',num2str(completedIdx),' F-',num2str(F),' I-',num2str(p.iter)]);
    end
end
    
% calculate optimal rho
opts.rho = 'optimal';
[X,F,p] = qp_admm(H,f,A,b,Aeq,beq,lb,ub,p,opts);
optrho = p.rho;

% calculate solution with quadprog
options = optimoptions('quadprog','OptimalityTolerance',eps,...
    'StepTolerance',eps,'disp','none');
[Xquadprog, Fquadprog] = quadprog(H,f,A,b,Aeq,beq,lb,ub,[],options);

% save results
path_name = mfoldername(mfilename('fullpath'),'results');
savestr = [path_name,'results-testnum',num2str(testnum),'-',opts.method,'-N',num2str(N)];
save(savestr,'R','Fall','Iall','optrho','Fquadprog')

% plot results
figure
loglog(R,abs(Fquadprog-4)*ones(size(R))); hold on
loglog(R,abs(Fall-4)); hold on
loglog([optrho,optrho],[1e-8,1e3]); hold on
ylim([min(abs(Fall-4)) max(abs(Fall-4))])

figure
loglog(R,Iall); hold on
loglog([optrho,optrho],[1,opts.maxiter]); hold on

% figure
% loglog(Iall,abs(Fall-4))
% % loglog([optrho,optrho],[1,opts.maxiter]); hold on
% ylim([min(abs(Fall-4)) max(abs(Fall-4))])


