%--------------------------------------------------------------------------
% iterate_admm_qp3.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/admm-qp
%--------------------------------------------------------------------------
function [x,iter] = iterate_admm_qp3(M,qb,Nbeq,A,b,At,rho,displevel,iterplot,tol,maxiter,p)
    % initialize
    e = Inf; iter = 0; hc = 0;
    z = zeros(size(A,2),1); % coupling variables
    v = zeros(size(A,2),1); % dual variables

    while (e > tol) && (iter < maxiter)
        % update iteration counter
        iter = iter + 1;
        % save previous iteration outputs
        zp = z; vp = v;
        % optimization variable
        x = M*(z + v - qb) + Nbeq;
        % coupling variable
        xv = x - v;
        z = xv - At*(max(0,(A*xv)-b));
        % dual variable
        v = v + z - x;
        % residuals
        r = (v-vp); % dual residuals
        s = rho*(z-zp); % coupling residuals
        % calculate error metric
        e = max(norm(r,2),norm(s,2));
        % (potentially) display to command window
        if displevel
            disp_iterations(iter,r,s);
        end
        if iterplot
            hc = plot_iterations(x,iter,p,hc);
        end
    end
end