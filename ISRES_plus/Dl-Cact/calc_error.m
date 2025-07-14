function [F,penalty,K,Soln] = calc_error(Params,modelname,dl0,cact0,reltol,abstol)
% Calculate the error (and penalty) of the dsat/negfb model. Params are in 
% log10 format.

warning('off','all')

if ~exist('modelname','var')
	modelname = 'decon';
end
if ~exist('dl0','var')
	dl0 = 1;
end
if ~exist('cact0','var')
	cact0 = 1;
end
if ~exist('reltol','var')
	reltol = 1e-7;
end
if ~exist('abstol','var')
	abstol = 1e-7;
end




% Experimental data - dl-Venus
C = dlVenusData('nuclear');   
C = C/1000;
%Cmat = Cmat/1000;
npts = length(C);


% 
% Initialize variables
%
n_sets  = size(Params,1);
F       = nan(n_sets,1);
K       = F;
Soln    = cell(n_sets,1);
if strcmp(modelname,'decon')
    penalty = nan(n_sets,2);	
else
    penalty = nan(n_sets,2);        % Change this!!  %%&&
end

%opts    = optimset('Display','off');



parfor(i = 1:n_sets)
    
    % 
    % Run model
    %
    params = 10.^(Params(i,:)); 
    try
        if strcmp(modelname,'decon')
            solnwt          = run_model(params,dl0,cact0,reltol,abstol);	
        elseif  strcmp(modelname,'dsat')
            solnwt          = run_model(params,dl0,cact0,reltol,abstol);
            %soln1x       = run_model(params,0.5*dl0,cact0,reltol,abstol);      % Change this!!  %%&&
        elseif strcmp(modelname,'negfb')
            [solnwt,K(i)]   = run_negfb(params,dl0,cact0,reltol,abstol);
           % soln1x          = run_model([params,K(i)],0.5*dl0,cact0,reltol,abstol);
        end
        
        Soln{i} = solnwt;
        
        % Simulation data as a column vector
        D         = [solnwt.nuclearDorsal.NC11(:);
                     solnwt.nuclearDorsal.NC12(:);
                     solnwt.nuclearDorsal.NC13(:);
                     solnwt.nuclearDorsal.NC14(:)];
        Dlnuc     = [solnwt.dlNuc.NC11(:);
                     solnwt.dlNuc.NC12(:);
                     solnwt.dlNuc.NC13(:);
                     solnwt.dlNuc.NC14(:)];
        DlCactnuc = [solnwt.dlCactNuc.NC11(:);
                     solnwt.dlCactNuc.NC12(:);
                     solnwt.dlCactNuc.NC13(:);
                     solnwt.dlCactNuc.NC14(:)]; 
        
        %
        % Calculate Error
        %
        Beta  = mean(D.*C)/mean(D.^2);
        epsln = (C-Beta*D);
        gamma = sum(epsln.^2);
        F(i)  = gamma;
        
                
               
        % 
        % Calculating Penalties
        %
        % Calculate Penalties 
        % 1. dlNuc should be closer to gregsData('nuclear') than dlCactNuc else, penalize.
        % 2. The dorsal-most nucleus must have less free dl than dl/Cact
        % complex else, penalize
        Beta1        = mean(Dlnuc.*C)/mean(Dlnuc.^2);
        Beta2        = mean(DlCactnuc.*C)/mean(DlCactnuc.^2);
        epsln1       = (C - Beta1*Dlnuc);
        epsln2       = (C - Beta2*DlCactnuc);

        phi          = [(sum(epsln1.^2) - sum(epsln2.^2))/npts, ...
                        solnwt.dlNuc.NC14(end,end) - solnwt.dlCactNuc.NC14(end,end)];
          
                    
                    
        %            
        % 2 additional penalties for negfb and dsat models    
        %{
        if strcmp(modelname,'negfb') || strcmp(modelname,'dsat')     
            % 
            % Penalty 3
            %
            % Herein, we compare the location of half-max intensities in the
            % wildtype case (2x embryo) and in the haploid case (1x embryo).
            % gtr:
            % Fit the final NC14 nuclearDorsal to a repressive Hill function, then 
            % get the half-max of the fit. Compare this half-max to the analog for 
            % the dorsal 2x situation. The expansion in the 1x must be greater than 
            % 1.5 nuclei (ie, x = 0.03) for there to be no penalty.
            
            % wt calc
            x       = solnwt.X.NC14;
            dg2     = solnwt.nuclearDorsal.NC14(:,end);
            hmax    = min(dg2) + 0.5*(max(dg2) - min(dg2));
            [~,i0]  = min(abs(dg2 - hmax));
            if i0==1
                i1 = [i0, i0+1];
            elseif i0==length(dg2)
                i1 = [i0-1, i0];
            else
                i1 = [i0-1, i0, i0+1];
            end
            zed1    = interp1(dg2(i1),x(i1),hmax);

            % haploid calc
            % Note that, here we use the dsat model as the right value
            % of "K" has already been found in the wildtype calculation
            dg1     = soln1x.nuclearDorsal.NC14(:,end);
            hmax    = min(dg1) + 0.5*(max(dg1) - min(dg1));
            [~,i0]  = min(abs(dg1 - hmax));
            if i0==1
                i1 = [i0, i0+1];
            elseif i0==length(dg1)
                i1 = [i0-1, i0];
            else
                i1 = [i0-1, i0, i0+1];
            end 
            zed2    = interp1(dg1(i1),x(i1),hmax);

            % calculate the difference
            z = zed1 - zed2;

            % check by plotting
            %{
            plot(x,[dg1,dg2])
            hold on
            plot([zed1,zed2],[0,0],'*')
            %}
            if z > 0.02                             % one nucleus diameter
                z = 0;
            else
                z = 1;
            end
            
         
            %
            % Penalty 4
            %
            % Dl profile from the ventral midline to about 40% of the
            % emrbyo will fit to a line with lesser slope for 1x than that
            % for wt
            [~,i0] = min(abs(x-0.4));           % x0 = 0.4
            xp    = x(1:i0);
            dgp1  = dg1(1:i0);           
            f1    = fit(xp,dgp1,'poly1');
            m1    = coeffvalues(f1);
            dgp2  = dg2(1:i0);
            f2    = fit(xp,dgp2,'poly1');        
            m2    = coeffvalues(f2);
            
            if abs(m1(1)) < abs(m2(1))
               mp = 0;
            else
               mp = 1;
            end
            
            phi = [phi, z, mp];
        end
        %}
       
        penalty(i,:) = phi;
                  
    catch ME
        disp(ME.message)
        F(i)            = nan;
        penalty(i,:)    = nan;
        solnwt          = nan;   
    end           
end



% old penalty 3 calculation    
	%{
    if strcmp(model,'negfb') || strcmp(model,'dsat')
        try
            x  = solnwt.X.NC14;
            dg = solnwt.nuclearDorsal.NC14(:,end);
            lastwarn('')
            [AA, BB, CC, DD] = fitstep(x, dg);
            msg = lastwarn;
            if strcmp(msg,'Complex Y detected. Will use real components only.')
                error(msg)
            end
            dgfit   = AA.*10.^(BB)./(10.^(BB)+x.^(2*CC))+DD;
            hmax    = min(dgfit) + 0.5*(max(dgfit)-min(dgfit));
            sft     = @(x) (AA.*10.^(BB))./(10.^(BB)+x.^(2*CC)) + DD - hmax;
            zed2    = fzero(sft,0.5,opts);

        catch ME
            disp(ME.message)
            disp('Error in fitting wt')
            continue
        end

        try        
            %
            % Note that, here we use the regular model as the right value
            % of "K" has already been found in the wildtype calculation
            %
            soln1x  = run_dsat(params,0.5*dl0,cact0,reltol,abstol);         
            dg      = soln1x.nuclearDorsal.NC14(:,end);
        catch ME
            disp(ME.message)
            disp('Error in haploid')
            continue
        end


        try
            lastwarn('')
            [AA, BB, CC, DD] = fitstep(x, dg);
            msg = lastwarn;
            if strcmp(msg,'Complex Y detected. Will use real components only.')
                error(msg)
            end
            dgfit   = AA.*10.^(BB)./(10.^(BB) + x.^(2*CC)) + DD;
            hmax    = min(dgfit) + 0.5*(max(dgfit) - min(dgfit));
            sft     = @(x) (AA.*10.^(BB))./(10.^(BB) + x.^(2*CC)) + DD - hmax;
            zed1    = fzero(sft, 0.5, opts);
            z       = zed1 - zed2;
            if z > 0.02                             % one nuclues diameter
                z = 0;
            else
                z = 1;
            end

        catch ME
            disp(ME.message)
            disp('Error in fitting haploid')
            continue
        end
        if isnan(z)
            z = 1;
        end
    else
        z = 0;
    end
	%}
 
    
	
