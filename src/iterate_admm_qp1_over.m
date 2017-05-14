%--------------------------------------------------------------------------
% iterate_admm_qp1_over.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/admm-qp
%--------------------------------------------------------------------------
function [x,iter] = iterate_admm_qp1_over(N1,N2,A,b,rho,alpha,displevel,iterplot,tol,maxiter,p)
    % initialize
    e = Inf; iter = 0; hc = 0;
    z = zeros(size(A,1),1); % coupling variables
    v = zeros(size(A,1),1); % dual variables

    while (e > tol) && (iter < maxiter)
        % update iteration counter
        iter = iter + 1;
        % save previous iteration outputs
        zp = z;
        % optimization variable
        x = N1 + N2*(z + v);
        % slack variable
        z = max(0, alpha*(b-A*x) + (1-alpha)*z - v);
        % dual variable
        v = v + alpha*(A*x + z - b) + (1-alpha)*(z-zp);
        % residuals
        r = A*x + z - b; % primal residuals
        s = rho*(z-zp); % residuals
        % calculate error metric
        e = max(norm(r,2),norm(s,2));
        % (potentially) display to command window
        if displevel
            disp_iterations(iter,r,s);
        end
        % (potentially) create iteration plot
        if iterplot
            hc = plot_iterations(x,iter,p,hc);
        end
    end
end