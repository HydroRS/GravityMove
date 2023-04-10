clc
clear
data_loc='P:\Work_2022\IrrWaterUse\ML_Irr\WU_spatial\All_data_read\';
[Intersect_data, Intersect_infor]=xlsread([data_loc,'Zhou_polygon_to_ours_new.xlsx']);
Intersect_infor=Intersect_infor(2:end,:);

Irr=xlsread([data_loc,'Irr_data.xlsx'],'Irr_Ling_Zhou'); %灌溉用水 km3/year
Ind=xlsread([data_loc,'Industry_data.xlsx'],'Industry_Ling_Zhou'); %工业用水 km3/year
Domestic=xlsread([data_loc,'Domestic_data.xlsx'],'Domestic_Ling_Zhou'); %生活用水 km3/year
Total_WU=[Irr(:,1:2),Irr(:,3:end)+Ind(:,3:end)+Domestic(:,3:end)];

%% 5-year average
Irr_5year=Irr(:,1:2);
Ind_5year=Ind(:,1:2);
Domestic_5year=Domestic(:,1:2);
Total_WU_5year=Total_WU(:,1:2);
start_col=4;
for ii=1:11
    Irr_5year=[Irr_5year,mean(Irr(:,start_col:start_col+4),2)]; % 1970 refers to 1966-1970
    Ind_5year=[Ind_5year,mean(Ind(:,start_col:start_col+4),2)];
    Domestic_5year=[Domestic_5year,mean(Domestic(:,start_col:start_col+4),2)];
    Total_WU_5year=[Total_WU_5year,mean(Total_WU(:,start_col:start_col+4),2)];
    start_col=start_col+5;
end

%% gravity movement
Irr_centriod=[];
Ind_centriod=[];
Domestic_centriod=[];
Total_WU_centriod=[];
for jj=3:13
    Irr_centriod=[Irr_centriod;[sum(Intersect_data(:,16).*Irr_5year(:,jj))/sum(Irr_5year(:,jj)),...
        sum(Intersect_data(:,17).*Irr_5year(:,jj))/sum(Irr_5year(:,jj))]];
    Ind_centriod=[Ind_centriod;[sum(Intersect_data(:,16).*Ind_5year(:,jj))/sum(Ind_5year(:,jj)),...
        sum(Intersect_data(:,17).*Ind_5year(:,jj))/sum(Ind_5year(:,jj))]];
    Domestic_centriod=[Domestic_centriod;[sum(Intersect_data(:,16).*Domestic_5year(:,jj))/sum(Domestic_5year(:,jj)),...
        sum(Intersect_data(:,17).*Domestic_5year(:,jj))/sum(Domestic_5year(:,jj))]];
    Total_WU_centriod=[Total_WU_centriod;[sum(Intersect_data(:,16).*Total_WU_5year(:,jj))/sum(Total_WU_5year(:,jj)),...
        sum(Intersect_data(:,17).*Total_WU_5year(:,jj))/sum(Total_WU_5year(:,jj))]];
end

%%
row_title={'year','Irr_Lon','Irr_lat','Ind_Lon','Ind_lat','Domestic_Lon','Domestic_lat','Total_WU_Lon','Total_WU_lat','Irr','Ind','Domestic','Total_WU'};
xlswrite('Gravity_Movement.xlsx',[row_title;num2cell([(1970:5:2020)',Irr_centriod,Ind_centriod,Domestic_centriod,Total_WU_centriod,sum(Irr_5year(:,3:end))',...
          sum(Ind_5year(:,3:end))',sum(Domestic_5year(:,3:end))',sum(Total_WU_5year(:,3:end))'])]);

