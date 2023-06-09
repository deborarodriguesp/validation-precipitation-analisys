%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Developed by Débora Rodrigues
%   LAPMAR (UFPA) and MARETEC (IST)
%   Date: 12/04/2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc

%% Load Observational
projectdir1 = 'E:\METEOROLOGIA\MERRA\NewAnalisys_INMETdata\Precip_INMET';% observational data folder location
files_ana=dir([projectdir1 '\*.txt']);

name = [];
 for k=1:length(files_ana)

    filename_ANA =[projectdir1 '\' files_ana(k).name];
    ana{k}= load (filename_ANA);
    name {k}= files_ana(k).name;
end
 
 name= name';
%% Load Model 
projectdir1 = 'E:\METEOROLOGIA\MERRA\NewAnalisys_INMETdata\Precip_NC';% model data folder location
files=dir([projectdir1 '\*.txt']);

 for k=1:length(files)
    filename =[projectdir1 '\' files(k).name];
    merra{k}= load ([filename]);
 end

%% Data trateament 
for k = 1:32
%% First I am checking if the dataset follows the rules. 
% Does start and end at the right times? If yes, analize. 
% Real Results (hourly results)

    ini = find(ana{k}==2010,1);
    %fin = find(ana{k}==2022,1);
    
    a = ana{k} (ini:end,1:5); 
    % you can use fin here instead of end
    % example: a = ana{k} (ini:fin-1,2);

    first = datetime(2010,01,01,0,0,0); 
    last = datetime(2021,12,31,23,59,59);
    x = (first:hours(1):last)';
    
    % Transforme to timetable to use Retime function
    P1 = array2table(a,'VariableNames',{'Year','Month','Day','Hour','Rainfall'});
    P = table2timetable(P1,'RowTimes',x);
    
    %% Transform to daily results
    p= retime(P,'daily',@sum);%'sum'
    p= timetable2table(p);
    
    % precipitation daily results
    a = table2array(p(:,6));
    
%% Removing higher values
    b= max(a);
    c = nanmean(a);
    a(a > 1.000e+03) = b;
    clear ini fin x
   
%Model results (daily results)
    p = merra{k}(:);  

%% Start the analyses 
% Following WMO guidelines for climate data

    dt = (first:hours(24):last)';
    
%% Filter "bad" data   
    if size(a)== size(p)
   
        day = [dt.Day];
        month = [dt.Month];
        year= [dt.Year];

        tP= [year month day a p];
        tP = array2table(tP);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Based on:
%https://www.mathworks.com/matlabcentral/answers/1793770-extract-all-data-for-the-june-months-over-the-years-from-a-timetable#answer_1040835
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

        tP.Properties.VariableNames={'Year','Month','Day','Rainfall','Model'};   % make meaningful variable name for data
        tG=groupsummary(tP,{'Month','Year'},"all","Rainfall");      % and do the work..
        tPnew = table2array(tP);
        
        %% Start removing months with >= 11 missing days 
        
        tJan=tG(tG.Month==1,:);
        var = tJan(1:12,["Year","nummissing_Rainfall"])

        if tJan.nummissing_Rainfall >=0 %simple value to force to enter in the loop
            % find for which year January has missing days
            
            idx_ano = find(var.nummissing_Rainfall >=11);% find the index 
            var = table2array(var); %tranform to table
            %If all you want to know is the value of a certain part of the matrix just call the index.
            % find the exact year: 
            value_ano= var(idx_ano);                
            s= size(value_ano,1); %know the size of the value_ano matrix
            value= num2cell(value_ano); %transform to cell to run in loop
            
            for i = 1:s
                ano1{i}= find(tPnew(:,2)==1 & tPnew == value{i}); %find the indices for month and year
                tPnew(ano1{i},:) = [];%remove values for ano1 positions in the tPnew matrix
            end
        end
        %repeat for the other months
        %%
        tFev=tG(tG.Month==2,:);
        var = tFev(1:12,["Year","nummissing_Rainfall"])

        if var.nummissing_Rainfall >=0
            idx_ano = find(var.nummissing_Rainfall >=11);

            var = table2array(var);
            value_ano= var(idx_ano);                
            s= size(value_ano,1);
            value= num2cell(value_ano);
            for i = 1:s
                ano1{i}= find(tPnew(:,2)==2 & tPnew == value{i});
                tPnew(ano1{i},:) = [];
            end
            clear ano1
        end
        %%
        tMar=tG(tG.Month==3,:);
        var = tMar(1:12,["Year","nummissing_Rainfall"])

        if var.nummissing_Rainfall >=0
            idx_ano = find(var.nummissing_Rainfall >=11);

            var = table2array(var);
            value_ano= var(idx_ano);               
            s= size(value_ano,1)
            value= num2cell(value_ano)
            for i = 1:s
                ano1{i}= find(tPnew(:,2)==3 & tPnew == value{i});
                tPnew(ano1{i},:) = [];
            end
            clear ano1
        end
        %%
        tApr=tG(tG.Month==4,:);
        var = tApr(1:12,["Year","nummissing_Rainfall"])

        if var.nummissing_Rainfall >=0
            idx_ano = find(var.nummissing_Rainfall >=11);

            var = table2array(var);
            value_ano= var(idx_ano);               
            s= size(value_ano,1);
            value= num2cell(value_ano);
            for i = 1:s
                ano1{i}= find(tPnew(:,2)==4 & tPnew == value{i});
                tPnew(ano1{i},:) = [];
            end
            clear ano1
        end
        %%
        tMay=tG(tG.Month==5,:);
        var = tMay(1:12,["Year","nummissing_Rainfall"])

        if var.nummissing_Rainfall >=0
            idx_ano = find(var.nummissing_Rainfall >=11);

            var = table2array(var);
            value_ano= var(idx_ano);              
            s= size(value_ano,1)
            value= num2cell(value_ano)
            for i = 1:s
                ano1{i}= find(tPnew(:,2)==5 & tPnew == value{i});
                tPnew(ano1{i},:) = [];
            end
            clear ano1
        end
        %%
        tJun=tG(tG.Month==6,:);
        var = tJun(1:12,["Year","nummissing_Rainfall"])

        if var.nummissing_Rainfall >=0
            idx_ano = find(var.nummissing_Rainfall >=11);

            var = table2array(var);
            value_ano= var(idx_ano);               
            s= size(value_ano,1);
            value= num2cell(value_ano);
            for i = 1:s
                ano1{i}= find(tPnew(:,2)==6 & tPnew == value{i});
                tPnew(ano1{i},:) = [];
            end
        end
        %%
        tJul=tG(tG.Month==7,:);
        var = tJul(1:12,["Year","nummissing_Rainfall"])

        if var.nummissing_Rainfall >=0
            idx_ano = find(var.nummissing_Rainfall >=11);

            var = table2array(var);
            value_ano= var(idx_ano);               
            s= size(value_ano,1)
            value= num2cell(value_ano)
            for i = 1:s
                ano1{i}= find(tPnew(:,2)==7 & tPnew == value{i});
                tPnew(ano1{i},:) = [];
            end
            clear ano1
        end
        %%
        tAug=tG(tG.Month==8,:);
        var = tAug(1:12,["Year","nummissing_Rainfall"])

        if var.nummissing_Rainfall >=0
            idx_ano = find(var.nummissing_Rainfall >=11);

            var = table2array(var);
            value_ano= var(idx_ano); 
            s= size(value_ano,1);
            value= num2cell(value_ano);
            
            for i = 1:s
                ano1{i}= find(tPnew(:,2)==8 & tPnew == value{i});
                tPnew(ano1{i},:) = [];
            end
            clear ano1
        end
        %%
        tSep=tG(tG.Month==9,:);
        var = tSep(1:12,["Year","nummissing_Rainfall"])

        if var.nummissing_Rainfall >=0
            idx_ano = find(var.nummissing_Rainfall >=11);

            var = table2array(var);
            value_ano= var(idx_ano);                
            s= size(value_ano,1);
            value= num2cell(value_ano);
            for i = 1:s
                ano1{i}= find(tPnew(:,2)==9 & tPnew == value{i});
                tPnew(ano1{i},:) = [];
            end
            clear ano1
        end
       
        %%
        tOct=tG(tG.Month==10,:);
        var = tOct(1:12,["Year","nummissing_Rainfall"])

        if var.nummissing_Rainfall >=0
            idx_ano = find(var.nummissing_Rainfall >=11);

            var = table2array(var);
            value_ano= var(idx_ano);                
            s= size(value_ano,1);
            value= num2cell(value_ano)
            for i = 1:s
                ano1{i}= find(tPnew(:,2)==10 & tPnew == value{i})
                tPnew(ano1{i},:) = [];
            end
            
        end    
        %%
        tNov=tG(tG.Month==11,:);
        var = tNov(1:12,["Year","nummissing_Rainfall"])

        if var.nummissing_Rainfall >=0
            idx_ano = find(var.nummissing_Rainfall >=11);

            var = table2array(var);
            value_ano= var(idx_ano);                
            s= size(value_ano,1);
            value= num2cell(value_ano);
            for i = 1:s
                ano1{i}= find(tPnew(:,2)==11 & tPnew == value{i});
                tPnew(ano1{i},:) = [];
            end
            clear ano1
        end
        %%
        tDec=tG(tG.Month==12,:);
        var = tDec(1:12,["Year","nummissing_Rainfall"])

        if var.nummissing_Rainfall >=0
            idx_ano = find(var.nummissing_Rainfall >=11);

            var = table2array(var);
            value_ano= var(idx_ano);  
            
            s= size(value_ano,1);
            value= num2cell(value_ano);
            
            for i = 1:s
                ano1{i}= find(tPnew(:,2)==12 & tPnew == value{1});
                %%
                tPnew(ano1{i},:) = [];
            end
            
        end
        
        %% Finished to remove months with more than 11 days missing data
        clear value var tJan tFev tMar tApr tMay tJun tJul tAug tSep tOct tNov tDec ano1 s value...
            value_ano idx_ano i
        %% Joining Matrix
        %create a new time vector 
        year = tPnew(:,1);
        month = tPnew(:,2);
        day = tPnew(:,3);
        dates = datenum([year,month,day]);
        
        %join the matrices
        m= [dates tPnew(:,4:5)];
       
        %% Percentage of NaN in the matrix
        % you can use this at the begging or here or not use at all.  
        T = sum(isnan(m(:)));
        T_Pct = 100*T/numel(m);
             
        %% use regexp to find sequences of consecutive NaNs of length at least 5:
        % I kept this block but i am basically just removing the other nans
        
        [start_idx,end_idx] = regexp(char('0'+isnan(m (:,3)).'),'1{5,}','start','end');
        to_remove = arrayfun(@(s,e)colon(s,e),start_idx,end_idx,'UniformOutput',false);
        to_remove = [to_remove{:}];
        m(to_remove,:) = []; %remove consecutive NaNs.
        
        m = rmmissing(m);% remove consecutive NaNs.
        clear to_remove start_idx end_idx year month day first last dt c b
        
        %% Convert to timetable again
        % Here we convert again to use retime for month, annual and climate
        % normal 
        
        days= m(:,1);
        days = datetime(days,'ConvertFrom','datenum');
        P = array2table(m,'VariableNames',{'time','ESTACAO','RSP'});
        P= table2timetable(P,'RowTimes',days);
        
        %% Daily 
        
        estd= m(:,2);
        modd= m(:,3);
        
        % Errors
        RMSE = rmse(estd,modd);
                
        N_S= NSE(estd,modd); 
        r = corr(estd,modd); 
        BIAS = sum(estd-modd)/sum(estd)*100;
        
        % wrong pbias:
        %B = mean(estd) - mean(modd)/sum(estd)*100
        %b = bias_skill(estd,modd)/sum(estd)*100

        %R2
        lm = fitlm(estd,modd);
        c= saveobj (lm);
        rsq=c.Rsquared.Ordinary;

        Derror{k}= [RMSE N_S r rsq BIAS T_Pct];
               
        %% Montlhy
        
        Pest= retime(P(:,2),'monthly', 'sum');%'sum'
        Psat = retime(P(:,3),'monthly','sum');
        Pm= [Pest Psat];
        
        %Monthly errors
        x= timetable2table(Pm);
        tx= x(:,1);  x= table2array(x(:,2:3));
        x = rmmissing(x);
        estm=x(:,1); modm=x(:,2);

        % Errors
        RMSE = rmse(estm,modm);
        N_S= NSE(estm,modm); 
        r = corr(estm,modm); 
        BIAS = sum(estm-modm)/sum(estm)*100;

        %R2
        lm = fitlm(estm,modm);
        c= saveobj (lm);
        rsq=c.Rsquared.Ordinary ;

        Merror{k}= [RMSE N_S r rsq BIAS T_Pct];

        %% Annually
        
        PYest= retime(P(:,2),'yearly', 'sum');%'sum'
        PYsat = retime(P(:,3),'yearly','sum');
        PY= [PYest PYsat];
        Pyear{k} =  PY;
        
        % Annual errors
        Pyear_est= Pyear{k}(:,1);
        Pyear_sat= Pyear{k}(:,2);
        esty= timetable2table(Pyear_est); esty= table2array(esty (:,2));
        mody= timetable2table(Pyear_sat); mody= table2array(mody(:,2));
        
        % Errors
        RMSE = rmse(esty,mody);
        N_S= NSE(esty,mody); 
        r = corr(esty,mody); 
        BIAS = (sum(esty-mody)/sum(esty))*100;

        %R2
        lm = fitlm(esty,mody);
        c= saveobj (lm);
        rsq=c.Rsquared.Ordinary ;

        Yerror {k}= [RMSE N_S r rsq BIAS T_Pct];
        
        %% Normal Climate 

        ESTavg = groupsummary(Pm, 'Time', 'monthofyear','mean','ESTACAO');
        SATavg = groupsummary(Pm, 'Time', 'monthofyear','mean','RSP');

        est= ESTavg (:,3); 
        mod= SATavg (:,3);
        time=ESTavg (:,1);
        Pnc= [time est mod];

        d= datenum(2010,1:12,1);
        d=d';

        estNC=table2array(est);
        modNC=table2array(mod);

        sumest= sum(estNC);
        sumsat= sum(modNC);
        
        % Normal Climate errors
        
        RMSE = rmse(estNC,modNC);
        N_S= NSE(estNC,modNC); 
        r = corr(estNC,modNC); 
        BIAS = (sum(estNC-modNC)/sum(estNC))*100;

        %R2
        lm = fitlm(estNC,modNC);
        c= saveobj (lm);
        rsq=c.Rsquared.Ordinary ;

        NCerror {k}= [RMSE N_S r rsq BIAS T_Pct];
        
        %% Clear variables we don't need anymore
        clear tP tPnew T T_Pct tG est mod ESTavg SATavg dates d PYest PYsat...
            Pyear_sat Pyear_est P1 Pest Psat
    else     
        
    end
end  

%% write each time scale errors into txt
Derror = Derror';
Derror = [name Derror];
writecell(Derror,'Derror.txt')

Merror = Merror';
Merror = [name Merror];
writecell(Merror,'Merror.txt')

Yerror=  Yerror';
Yerror=  [name Yerror ];
writecell(Yerror,'Yerror.txt')


NCerror=  NCerror';
NCerror=  [name NCerror];
writecell(NCerror,'NCerror.txt')

