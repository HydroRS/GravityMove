clc
clear
data_loc='P:\Work_2022\IrrWaterUse\ML_Irr\WU_spatial\All_data_read\';
[Intersect_data, Intersect_infor]=xlsread([data_loc,'Zhou_polygon_to_ours_new.xlsx']);
Intersect_infor=Intersect_infor(2:end,:);

Irr=xlsread([data_loc,'Irr_data.xlsx'],'Irr_Ling_Zhou'); %灌溉用水 km3/year
Ind=xlsread([data_loc,'Industry_data.xlsx'],'Industry_Ling_Zhou'); %工业用水 km3/year
Domestic=xlsread([data_loc,'Domestic_data.xlsx'],'Domestic_Ling_Zhou'); %生活用水 km3/year
Total_WU=[Irr(:,1:2),Irr(:,3:end)+Ind(:,3:end)+Domestic(:,3:end)];

province=xlsread('Province_merge.xlsx');
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

%%
province_id=unique(Irr(:,2));
[intersect_value,id01, id02]=intersect(province_id,province(:,3));
X_Y=province(id02,4:5);


%% gravity movement
Irr_centriod=[];
Ind_centriod=[];
Domestic_centriod=[];
Total_WU_centriod=[];
for jj=3:13
    TWU_province=[];
    for ii=1:31
        id=find(Total_WU_5year(:,2)==intersect_value(ii));
        TWU_province=[TWU_province;sum(Total_WU_5year(id,jj))];
    end

    Total_WU_centriod=[Total_WU_centriod;[sum(X_Y(:,1).*TWU_province)/sum(TWU_province),sum(X_Y(:,2).*TWU_province)/sum(TWU_province)]];
end

%%
row_title={'year','Total_WU_Lon','Total_WU_lat'};
xlswrite('Gravity_Movement_province_test.xlsx',[row_title;num2cell([(1970:5:2020)',Total_WU_centriod])]);

%%
Irr_centriod=[];
Ind_centriod=[];
Domestic_centriod=[];
Total_WU_centriod=[];
for jj=3:13
    TWU_province=[];
    for ii=1:31
        id=find(Irr_5year(:,2)==intersect_value(ii));
        TWU_province=[TWU_province;sum(Irr_5year(id,jj))];
    end

    Total_WU_centriod=[Total_WU_centriod;[sum(X_Y(:,1).*TWU_province)/sum(TWU_province),sum(X_Y(:,2).*TWU_province)/sum(TWU_province)]];
end

%%
row_title={'year','Total_WU_Lon','Total_WU_lat'};
xlswrite('Gravity_Movement_province_test.xlsx',[row_title;num2cell([(1970:5:2020)',Total_WU_centriod])], 'irr');

%%
Irr_centriod=[];
Ind_centriod=[];
Domestic_centriod=[];
Total_WU_centriod=[];
for jj=3:13
    TWU_province=[];
    for ii=1:31
        id=find(Ind_5year(:,2)==intersect_value(ii));
        TWU_province=[TWU_province;sum(Ind_5year(id,jj))];
    end

    Total_WU_centriod=[Total_WU_centriod;[sum(X_Y(:,1).*TWU_province)/sum(TWU_province),sum(X_Y(:,2).*TWU_province)/sum(TWU_province)]];
end

%%
row_title={'year','Total_WU_Lon','Total_WU_lat'};
xlswrite('Gravity_Movement_province_test.xlsx',[row_title;num2cell([(1970:5:2020)',Total_WU_centriod])], 'ind');

