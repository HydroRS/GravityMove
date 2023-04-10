clc
clear
data_loc='P:\Work_2022\IrrWaterUse\ML_Irr\WU_spatial\All_data_read\';
[Intersect_data, Intersect_infor]=xlsread([data_loc,'Zhou_polygon_to_ours_new.xlsx']);
Intersect_infor=Intersect_infor(2:end,:);

Irr=xlsread([data_loc,'Irr_data.xlsx'],'Irr_Ling_Zhou'); %灌溉用水 km3/year
IrrArea=xlsread([data_loc,'IrrArea_data.xlsx'],'IrrArea_Ling_Zhou'); %灌溉面积： Kha

Ind=xlsread([data_loc,'Industry_data.xlsx'],'Industry_Ling_Zhou'); %工业用水 km3/year
IndGVA=xlsread([data_loc,'IndustryGVA_data.xlsx'],'IndustryGVA_Ling_Zhou'); %工业增加值：billion Yuan

Domestic=xlsread([data_loc,'Domestic_data.xlsx'],'Domestic_Ling_Zhou'); %生活用水 km3/year
Population=xlsread([data_loc,'Population_data.xlsx'],'Population_Ling_Zhou'); %生活用水 km3/year

Total_WU=[Irr(:,1:2),Irr(:,3:end)+Ind(:,3:end)+Domestic(:,3:end)];

%% 5-year average
Irr_5year=Irr(:,1:2);
IrrArea_5year=Irr(:,1:2);
IrrWUI_5year=Irr(:,1:2);

Ind_5year=Ind(:,1:2);
IndGVA_5year=Ind(:,1:2);
IndWUI_5year=Ind(:,1:2);

Domestic_5year=Domestic(:,1:2);
Pop_5year=Domestic(:,1:2);
DomesticWUI_5year=Domestic(:,1:2);

Total_WU_5year=Total_WU(:,1:2);
start_col=4;
for ii=1:11
    Irr_5year=[Irr_5year,mean(Irr(:,start_col:start_col+4),2)]; % 1970 refers to 1966-1970
    IrrArea_5year=[IrrArea_5year,mean(IrrArea(:,start_col:start_col+4),2)];
    IrrWUI_5year=[IrrWUI_5year,mean(Irr(:,start_col:start_col+4),2)./mean(IrrArea(:,start_col:start_col+4),2)];
    
    Ind_5year=[Ind_5year,mean(Ind(:,start_col:start_col+4),2)];
    IndGVA_5year=[IndGVA_5year,mean(IndGVA(:,start_col:start_col+4),2)];
    IndWUI_5year=[IndWUI_5year,mean(Ind(:,start_col:start_col+4),2)./mean(IndGVA(:,start_col:start_col+4),2)];
    
    Domestic_5year=[Domestic_5year,mean(Domestic(:,start_col:start_col+4),2)];
     Pop_5year=[Pop_5year,mean(Population(:,start_col:start_col+4),2)];
    DomesticWUI_5year=[DomesticWUI_5year,mean(Domestic(:,start_col:start_col+4),2)./mean(Population(:,start_col:start_col+4),2)];
    
    Total_WU_5year=[Total_WU_5year,mean(Total_WU(:,start_col:start_col+4),2)];
    start_col=start_col+5;
end
%%
% YAO S. On the decomposition of Gini coefficients by population class 
% and income source: a spreadsheet approach and application. Applied Economics, 1999, 31(10):1249-1264.
% ===================================================================================================

% P=Pop_5year(:,3);
% Gini_all=[];
% for kk=3:13
%    Gini_IRR = Function_Gini(Irr_5year(:,kk),Pop_5year(:,kk));
%    Gini_Ind = Function_Gini(Ind_5year(:,kk),Pop_5year(:,kk) );
%    Gini_Domestic = Function_Gini(Domestic_5year(:,kk),Pop_5year(:,kk));
%    Gini_Total_WU = Function_Gini(Total_WU_5year(:,kk),Pop_5year(:,kk));
%    Gini_all=[Gini_all;[Gini_IRR,Gini_Ind,Gini_Domestic,Gini_Total_WU]];
% end

%% Factor contribution
% Contribute_all=[];
% for kk=3:13
%     Contri_IRR = Function_sector_factor(Irr_5year(:,kk),IrrArea_5year(:,kk),IrrWUI_5year(:,kk),Pop_5year(:,kk));
%     Contri_Ind =Function_sector_factor(Ind_5year(:,kk),IndGVA_5year(:,kk),IndWUI_5year(:,kk),Pop_5year(:,kk));
%     Contri_Domestic = Function_sector_factor(Domestic_5year(:,kk),Pop_5year(:,kk),DomesticWUI_5year(:,kk),Pop_5year(:,kk));
%    
%    Contribute_all=[Contribute_all;[Contri_IRR',...
%                                    Contri_Ind',...
%                                    Contri_Domestic',...
%                                    Function_Gini(IrrArea_5year(:,kk),Pop_5year(:,kk)),Function_Gini(IrrWUI_5year(:,kk),Pop_5year(:,kk)),...
%                                    Function_Gini(IndGVA_5year(:,kk),Pop_5year(:,kk)),Function_Gini(IndWUI_5year(:,kk),Pop_5year(:,kk)),...
%                                    Function_Gini(Pop_5year(:,kk),Pop_5year(:,kk)),Function_Gini(DomesticWUI_5year(:,kk),Pop_5year(:,kk))]];
% end
% 
% C=[Contribute_all(:,1)./sum(Contribute_all(:,1:2),2),Contribute_all(:,2)./sum(Contribute_all(:,1:2),2),...
%     Contribute_all(:,3)./sum(Contribute_all(:,3:4),2),Contribute_all(:,4)./sum(Contribute_all(:,3:4),2),...
%     Contribute_all(:,5)./sum(Contribute_all(:,5:6),2),Contribute_all(:,6)./sum(Contribute_all(:,5:6),2)];
Contribute_all=[];
  for jj=3:13
      % irrigation
   Irr_temp=Irr_5year(:,jj);
   Pop_temp=Pop_5year(:,jj);
   IrrArea_temp=IrrArea_5year(:,jj);
   IrrWUI_temp=IrrWUI_5year(:,jj);
   xy=Function_Gini(Irr_temp,Pop_temp);
   xPy=Function_Gini((repmat(mean(IrrArea_temp./Pop_temp),340,1).*IrrWUI_temp).*Pop_temp, Pop_temp);
   xyP=Function_Gini((repmat(mean(IrrWUI_temp),340,1).*IrrArea_temp./Pop_temp).*Pop_temp, Pop_temp);
 %  xyP=Function_Gini((repmat(mean(IrrWUI_temp./Pop_temp),340,1).*IrrArea_temp).*Pop_temp, Pop_temp);
   xPyP=Function_Gini((repmat(mean(IrrArea_temp./Pop_temp),340,1).*repmat(mean(IrrWUI_temp),340,1)).*Pop_temp, Pop_temp);
   Cx=0.5*(xy-xPy+xyP-xPyP); % IrrArea contribution
   Cy=0.5*(xy-xyP+xPy-xPyP); % IrrWUI contribution
   
   % industrial water use
     Irr_temp=Ind_5year(:,jj);
   Pop_temp=Pop_5year(:,jj);
   IrrArea_temp=IndGVA_5year(:,jj);
   IrrWUI_temp=IndWUI_5year(:,jj);
   xy=Function_Gini(Irr_temp,Pop_temp);
   xPy=Function_Gini((repmat(mean(IrrArea_temp./Pop_temp),340,1).*IrrWUI_temp).*Pop_temp, Pop_temp); 
   xyP=Function_Gini((repmat(mean(IrrWUI_temp),340,1).*IrrArea_temp./Pop_temp).*Pop_temp, Pop_temp);
 % xyP=Function_Gini((repmat(mean(IrrWUI_temp./Pop_temp),340,1).*IrrArea_temp).*Pop_temp, Pop_temp);
   xPyP=Function_Gini((repmat(mean(IrrArea_temp./Pop_temp),340,1).*repmat(mean(IrrWUI_temp),340,1)).*Pop_temp, Pop_temp);

   Dx=0.5*(xy-xPy+xyP-xPyP);
   Dy=0.5*(xy-xyP+xPy-xPyP);
   
   Contribute_all=[Contribute_all;[Cx,Cy,Dx,Dy]];
   
  end
%%
row_title={'year', 'IrrArea_Contri','IrrWUI_Contri','IndGVA_Contri','IndWUI_Contri'};
xlswrite('Gini_WU_factors_new.xlsx',[row_title;num2cell([(1970:5:2020)',Contribute_all])]);


