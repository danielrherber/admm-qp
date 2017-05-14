%--------------------------------------------------------------------------
% qp_admm_opts.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/admm-qp
%--------------------------------------------------------------------------
function opts = qp_admm_opts(opts)

    % method
    if ~isfield(opts,'method')
       opts.method = 'qp-1-over';
%        opts.method = 'qp-1';
%        opts.method = 'qp-3';
    end
    
    % preconditioning
    if ~isfield(opts,'preconditioning')
        opts.preconditioning = 0; % off
%         opts.preconditioning = 1; % on
    end

    % convergence tolerance
    if ~isfield(opts,'tol')
        opts.tol = 1e-6;
    end
    
    % maximum number of iterations
    if ~isfield(opts,'maxiter')
        opts.maxiter = 1e6;
    end
    
    % penalty parameter
    if ~isfield(opts,'rho')
       opts.rho = 'optimal'; 
%        opts.rho = 1; % constant
    end

    % over-relaxed ADMM iterations parameter (qp-1-over method)
    if ~isfield(opts,'alpha')
        opts.alpha = 1.7;
    end
    
    % display level
    if ~isfield(opts,'displevel')
        opts.displevel = 0; % don't display
%         opts.displevel = 1; % display
    end
    
    % iteration plot (currently unavailable)
    if ~isfield(opts,'iterplot')
        opts.iterplot = 0; % don't display
%         opts.iterplot = 1; % display
    end
    
    % initialize iteration plot (currently unavailable)
    if opts.iterplot 
        close all
        hL = figure('Color',[1 1 1]);
        movegui(hL,[100 100])
        pause(0.5)
    end
    
end