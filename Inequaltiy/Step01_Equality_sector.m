clc
clear
data_loc='P:\Work_2022\IrrWaterUse\ML_Irr\WU_spatial\All_data_read\';
[Intersect_data, Intersect_infor]=xlsread([data_loc,'Zhou_polygon_to_ours_new.xlsx']);
Intersect_infor=Intersect_infor(2:end,:);

Irr=xlsread([data_loc,'Irr_data.xlsx'],'Irr_Ling_Zhou'); %灌溉用水 km3/year
Pop=xlsread([data_loc,'Population_data.xlsx'],'Population_Ling_Zhou'); %人口 100万人
Ind=xlsread([data_loc,'Industry_data.xlsx'],'Industry_Ling_Zhou'); %工业用水 km3/year
Domestic=xlsread([data_loc,'Domestic_data.xlsx'],'Domestic_Ling_Zhou'); %生活用水 km3/year
Total_WU=[Irr(:,1:2),Irr(:,3:end)+Ind(:,3:end)+Domestic(:,3:end)];

%% 5-year average
Irr_5year=Irr(:,1:2);
Pop_5year=Pop(:,1:2);
Ind_5year=Ind(:,1:2);
Domestic_5year=Domestic(:,1:2);
Total_WU_5year=Total_WU(:,1:2);
start_col=4;
for ii=1:11
    Irr_5year=[Irr_5year,mean(Irr(:,start_col:start_col+4),2)]; % 1970 refers to 1966-1970
    Pop_5year=[Pop_5year,mean(Pop(:,start_col:start_col+4),2)]; % 1970 refers to 1966-1970
    Ind_5year=[Ind_5year,mean(Ind(:,start_col:start_col+4),2)];
    Domestic_5year=[Domestic_5year,mean(Domestic(:,start_col:start_col+4),2)];
    Total_WU_5year=[Total_WU_5year,mean(Total_WU(:,start_col:start_col+4),2)];
    start_col=start_col+5;
end
%%
% YAO S. On the decomposition of Gini coefficients by population class 
% and income source: a spreadsheet approach and application. Applied Economics, 1999, 31(10):1249-1264.
% ===================================================================================================

% P=Pop_5year(:,3);
Gini_all=[];
for kk=3:13
   Gini_IRR = Function_Gini(Irr_5year(:,kk),Pop_5year(:,kk));
   Gini_Ind = Function_Gini(Ind_5year(:,kk),Pop_5year(:,kk) );
   Gini_Domestic = Function_Gini(Domestic_5year(:,kk),Pop_5year(:,kk));
   Gini_Total_WU = Function_Gini(Total_WU_5year(:,kk),Pop_5year(:,kk));
   Gini_all=[Gini_all;[Gini_IRR,Gini_Ind,Gini_Domestic,Gini_Total_WU]];
end

%% Sector contribution
C_all=[];
for kk=3:13
   C_IRR = Function_Concentration(Irr_5year(:,kk),Pop_5year(:,kk),Total_WU_5year(:,kk) );
   C_Ind = Function_Concentration(Ind_5year(:,kk),Pop_5year(:,kk),Total_WU_5year(:,kk) );
   C_Domestic = Function_Concentration(Domestic_5year(:,kk),Pop_5year(:,kk),Total_WU_5year(:,kk) );
   sector_proportion=[sum(Irr_5year(:,kk))/sum(Total_WU_5year(:,kk)),sum(Ind_5year(:,kk))/sum(Total_WU_5year(:,kk)),sum(Domestic_5year(:,kk))/sum(Total_WU_5year(:,kk))];
   Gini_TWU=sum([C_IRR,C_Ind,C_Domestic].*sector_proportion);
   C_all=[C_all;[C_IRR,C_Ind,C_Domestic,sector_proportion,Gini_TWU]];
end
C_all=[C_all,C_all(:,1).*C_all(:,4)./C_all(:,end),C_all(:,2).*C_all(:,5)./C_all(:,end),C_all(:,3).*C_all(:,6)./C_all(:,end)];

%%
row_title={'year','Irr_Gini','Ind_Gini','Domestic_Gini','Total_WU_Gini'};
xlswrite('Gini_WU.xlsx',[row_title;num2cell([(1970:5:2020)',Gini_all])],'Gini_all');

row_title={'year','Irr_C','Ind_C','Domestic_C','Irr_Pro','Ind_Pro','Domestic_Pro','Gini_TWU','Irr_contri','Ind_contri','Domestic_contri'};
xlswrite('Gini_WU.xlsx',[row_title;num2cell([(1970:5:2020)',C_all])],'C_all');

