%--------------------------------------------------------------------------
% plot_iterations.m
% 
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/admm-qp
%--------------------------------------------------------------------------
function hc = plot_iterations(x,iter,p,hc)

    if (mod(iter,p.N) == 0) || (iter == 1)

        set(0,'DefaultTextInterpreter','latex'); % change the text interpreter
        set(0,'DefaultLegendInterpreter','latex'); % change the legend interpreter
        set(0,'DefaultAxesTickLabelInterpreter','latex'); % change the tick interpreter

        if (iter > 1)
            hc.Color = [0.5 0.5 0.5]; % fade previous
        end

        % plot true solution
        plot(p.t,p.Xfun(p),'b','linewidth',2); hold on

        % plot current iteration
        hc = plot(p.t,x(p.I),'r','linewidth',2); hold on

        % custom axis limits
        xlim([p.t(1) p.t(end)]);
    %     ylim([-12 12]); 

        % title
        title(['Iteration number: ',num2str(iter)])
        xlabel('$t$ (s)','interpreter','latex','fontsize',17)
    %     ylabel('$\xi_1$','interpreter','latex','fontsize',17)
%         hc.CurrentAxes.FontSize = 14;

        % short delay
        pause(0.05)
    end

end