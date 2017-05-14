%--------------------------------------------------------------------------
% qp_admm.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/admm-qp
%--------------------------------------------------------------------------
function [X,F,p] = qp_admm(H,f,A,b,Aeq,beq,lb,ub,p,opts)

% get options
 opts = qp_admm_opts(opts);
alpha = opts.alpha;
maxiter = opts.maxiter;
tol = opts.tol;
displevel = opts.displevel;
iterplot = opts.iterplot;

% number of optimization variables
nx = length(H);

% find lower bounds
i = find(lb~=-Inf);
Alb = sparse(1:numel(i),i,1,numel(i),nx);
blb = lb(i);

% find upper bounds
i = find(ub~=Inf);
Aub = sparse(1:numel(i),i,1,numel(i),nx);
bub = ub(i);

% combine matrices
switch opts.method
    case {'qp-1','qp-1-over'}
        A = [A;Aeq;-Aeq;-Alb;Aub];
        b = [b;beq;-beq;-blb;bub];
    case 'qp-3'
        A = [A;-Alb;Aub];
        b = [b;-blb;bub];
end

% preconditioning
if opts.preconditioning
    Hnorm = normest(H);
    f = f/Hnorm;
    H = H/Hnorm;
    Anorm = normest(A);
    b = b/Anorm;
    A = A/Anorm;
    % method specific preconditioning
    switch opts.method
        case {'qp-1','qp-1-over'}
            % nothing
        case 'qp-3'
            Aeqnorm = normest(Aeq);
            beq = beq/Aeqnorm;
            Aeq = Aeq/Aeqnorm;
    end
end

% calculate rho
switch opts.rho
    case 'optimal'
        switch opts.method
            case {'qp-1','qp-1-over'}
                % check if H is invertible
                if condest(H) < 1/(max(size(H))*eps)
                    Ht = A*(H\(A'));
                else
                    warning(['H is not pd, ','using pseudoinverse']);
                    Ht = A*pseudoinverse(H)*A';
                end
                OPTIONS.maxit = 10000; OPTIONS.tol = eps;
                Smax = svds(Ht,1,'largest');
                Smin = svds(Ht,1,'smallestnz',OPTIONS);
                rho = 1/sqrt(Smin*Smax);                    
            case 'qp-3'
                Z = spnull(Aeq);
                Qt = Z'*H*Z;
                Qt = (Qt+Qt')/2; % ensure that it is symmetric
                OPTIONS.maxit = 10000; OPTIONS.tol = eps;
                E(1) = svds(Qt,1,'largest');
                E(2) = svds(Qt,1,'smallestnz',OPTIONS);
                % check if the matrix is pd
                if E(2) > eps
                    rho = sqrt(prod(E));
                else
                    warning(['Z''*H*Z is not pd, ',...
                        'cannot determine optimal rho, ',...
                        'this method may not solve the qp']);
                    rho = 1;
                end
        end
    otherwise % constant rho
        rho = opts.rho;
end
      
% precalculate matrices
switch opts.method
    case {'qp-1','qp-1-over'}
        N = -(H + rho*(A'*A));
        N2 = N\(rho*A');
        N1 = N\(f - rho*A'*b);
    case 'qp-3'
        At = pseudoinverse(A);
        At = speye(size(At,1))*At; % convert to double
        R = sporth(Aeq');
        Z = spnull(Aeq);
        M = Z*((Z'*((H/rho + eye(size(H)))*Z))\(Z'));    
        Nbeq = (eye(size(H)) - M*H/rho)*R*((Aeq*R)\beq);
        qb = f/rho;
end

% solve
switch opts.method
    case 'qp-1'
        [x,iter] = iterate_admm_qp1(N1,N2,A,b,rho,displevel,iterplot,tol,maxiter,p);
    case 'qp-1-over'
        [x,iter] = iterate_admm_qp1_over(N1,N2,A,b,rho,alpha,displevel,iterplot,tol,maxiter,p);
    case 'qp-3'
        [x,iter] = iterate_admm_qp3(M,qb,Nbeq,A,b,At,rho,displevel,iterplot,tol,maxiter,p);
end

% outputs
X = x; % optimization variables
F = 1/2*X'*H*X + f'*X; % objective function
if opts.preconditioning
    F = F*Hnorm;
end
if iter == maxiter
    X = nan*X;
	F = nan;
    iter = nan;
end
p.iter = iter; % save iteration count
p.rho = rho; % save rho



end