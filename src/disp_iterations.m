%--------------------------------------------------------------------------
% disp_iterations.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/admm-qp
%--------------------------------------------------------------------------
function disp_iterations(iter,r,s)
    disp([num2str(iter),' ', num2str(norm(r,inf)),' ',num2str(norm(s,inf))])
end