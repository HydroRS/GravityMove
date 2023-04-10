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
province=unique(Irr_5year(:,2));
IRR_province=[];
Ind_province=[];
Domestic_province=[];
Total_WU_province=[];
Pop_province=[];
for hh=1:31
    id=find(Irr_5year(:,2)==province(hh));
    if length(id)==1
        IRR_province=[IRR_province;Irr_5year(id,3:end)];
        Ind_province=[Ind_province;Ind_5year(id,3:end)];
        Domestic_province=[Domestic_province;Domestic_5year(id,3:end)];
       Total_WU_province=[Total_WU_province;Total_WU_5year(id,3:end)];
        Pop_province=[Pop_province;Pop_5year(id,3:end)];
    else
        IRR_province=[IRR_province;sum(Irr_5year(id,3:end),1)];
        Ind_province=[Ind_province;sum(Ind_5year(id,3:end),1)];
        Domestic_province=[Domestic_province;sum(Domestic_5year(id,3:end),1)];
        Total_WU_province=[Total_WU_province;sum(Total_WU_5year(id,3:end),1)];
        Pop_province=[Pop_province;sum(Pop_5year(id,3:end),1)];
    end
end
%%
Gini_all=[];
for kk=3:13
   Gini_IRR = Function_Gini(Irr_5year(:,kk),Pop_5year(:,kk));
   Gini_Ind = Function_Gini(Ind_5year(:,kk),Pop_5year(:,kk) );
   Gini_Domestic = Function_Gini(Domestic_5year(:,kk),Pop_5year(:,kk));
   Gini_Total_WU = Function_Gini(Total_WU_5year(:,kk),Pop_5year(:,kk));
   Gini_all=[Gini_all;[Gini_IRR,Gini_Ind,Gini_Domestic,Gini_Total_WU]];
end

Ga_all=[];
for kk=1:11
    Ga_Irr = Function_Gini(IRR_province(:,kk),Pop_province(:,kk));
    Ga_Ind = Function_Gini(Ind_province(:,kk),Pop_province(:,kk));
    Ga_Domestic = Function_Gini(Domestic_province(:,kk),Pop_province(:,kk) );
    Ga_Total_WU = Function_Gini(Total_WU_province(:,kk),Pop_province(:,kk));
    Ga_all=[Ga_all;[Ga_Irr,Ga_Ind,Ga_Domestic,Ga_Total_WU]];
end

GI_all=[];
for kk=3:13
    GI_Irr = Function_GI_calculate(province,Irr_5year(:,2),Irr_5year(:,kk),Pop_5year(:,kk),IRR_province(:,kk-2),Pop_province(:,kk-2));
    GI_Ind = Function_GI_calculate(province,Ind_5year(:,2),Ind_5year(:,kk),Pop_5year(:,kk),Ind_province(:,kk-2),Pop_province(:,kk-2));
    GI_Domestic = Function_GI_calculate(province,Domestic_5year(:,2),Domestic_5year(:,kk),Pop_5year(:,kk),Domestic_province(:,kk-2),Pop_province(:,kk-2) );
    GI_Total_WU =Function_GI_calculate( province,Total_WU_5year(:,2),Total_WU_5year(:,kk),Pop_5year(:,kk),Total_WU_province(:,kk-2),Pop_province(:,kk-2) );
    GI_all=[GI_all;[GI_Irr,GI_Ind,GI_Domestic,GI_Total_WU]];
end

GO=Gini_all-Ga_all-GI_all;

%% doublecheck the reuslts
% 下面用另一种方法计算GO,和上述方法一致。
% P=Pop_5year(:,3);
% WU=Irr_5year(:,3);
% Mi=WU./P; % 人均用水
% Pi=P/sum(P); % 人口比例
% PiMi=Pi.*Mi; 
% Wi=PiMi/(sum(WU)/sum(P));% 区域i用水量占全国总用水比例=WUi/sum(WU)
% % 省份排序
% [order,id00]= sort(IRR_province(:,1)./Pop_province(:,1),'ascend'); 
% province_order=province(id00);
% original_order=(1:340)';
% city_all_order=[];
% city_all_order_new=[];
% for mm=1:31
%     id=find(Irr_5year(:,2)==province_order(mm));
%     city_all_order=[city_all_order;original_order(id)];
%     city_all_order_new=[city_all_order_new;Irr_5year(id,2)];
% end
% order_id_all=[];
% Mi_new=Mi(city_all_order);
% for mm=1:31
%     id=find(city_all_order_new==province_order(mm));
%     % 省内排序
%     temp=city_all_order(id);
%     [order,id01]= sort(Mi_new(id),'ascend');
%     order_id_all=[order_id_all;temp(id01)];
% end
% Qi=cumsum(Wi(order_id_all));
% Gini=1-sum(Pi(order_id_all).*(2*Qi-Wi(order_id_all)));
% GO_new=Gini_all(1)-Gini;

%%
% row_title={'year','Irr_Inter','Irr_Intra','Irr_GO','Ind_Inter','Ind_Intra','Ind_GO','Domestic_Inter',...
%         'Domestic_Intra','Domestic_GO','TWU_Inter','TWU_Intra','TWU_GO',};
% xlswrite('Gini_WU_decomp.xlsx',[row_title;num2cell([(1970:5:2020)',Ga_all(:,1),GI_all(:,1),GO(:,1),...
%                                     Ga_all(:,2),GI_all(:,2),GO(:,2),...
%                                     Ga_all(:,3),GI_all(:,3),GO(:,3),...
%                                     Ga_all(:,4),GI_all(:,4),GO(:,4),...
%                                     ])]);



