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

%% gravity movement
IrrArea_centriod=[];
IrrWUI_centriod=[];
IndGVA_centriod=[];
IndWUI_centriod=[];
Pop_centriod=[];
DomesticWUI_centriod=[];
for jj=3:13
    IrrArea_centriod=[IrrArea_centriod;[sum(Intersect_data(:,16).*IrrArea_5year(:,jj))/sum(IrrArea_5year(:,jj)),...
        sum(Intersect_data(:,17).*IrrArea_5year(:,jj))/sum(IrrArea_5year(:,jj))]];
    IrrWUI_centriod=[IrrWUI_centriod;[sum(Intersect_data(:,16).*IrrWUI_5year(:,jj))/sum(IrrWUI_5year(:,jj)),...
        sum(Intersect_data(:,17).*IrrWUI_5year(:,jj))/sum(IrrWUI_5year(:,jj))]];
    
    IndGVA_centriod=[IndGVA_centriod;[sum(Intersect_data(:,16).*IndGVA_5year(:,jj))/sum(IndGVA_5year(:,jj)),...
        sum(Intersect_data(:,17).*IndGVA_5year(:,jj))/sum(IndGVA_5year(:,jj))]];
    IndWUI_centriod=[IndWUI_centriod;[sum(Intersect_data(:,16).*IndWUI_5year(:,jj))/sum(IndWUI_5year(:,jj)),...
        sum(Intersect_data(:,17).*IndWUI_5year(:,jj))/sum(IndWUI_5year(:,jj))]];
    
     Pop_centriod=[Pop_centriod;[sum(Intersect_data(:,16).*Pop_5year(:,jj))/sum(Pop_5year(:,jj)),...
        sum(Intersect_data(:,17).*Pop_5year(:,jj))/sum(Pop_5year(:,jj))]];
    DomesticWUI_centriod=[DomesticWUI_centriod;[sum(Intersect_data(:,16).*DomesticWUI_5year(:,jj))/sum(DomesticWUI_5year(:,jj)),...
        sum(Intersect_data(:,17).*DomesticWUI_5year(:,jj))/sum(DomesticWUI_5year(:,jj))]];
end

%%
row_title={'year','IrrArea_Lon','IrrArea_lat','IrrWUI_Lon','IrrWUI_lat',...
    'IndGVA_Lon','IndGVA_lat','IndWUI_Lon','IndWUI_lat',...
    'Pop_Lon','Pop_lat','DomesticWUI_Lon','DomesticWUI_lat','IrrArea','IrrWUI', 'IndGVA', 'IndWUI','Pop','DomWUI'};
xlswrite('Gravity_Movement_factors.xlsx',[row_title;num2cell([(1970:5:2020)',IrrArea_centriod,IrrWUI_centriod,IndGVA_centriod,IndWUI_centriod,...
                                Pop_centriod,DomesticWUI_centriod,sum(IrrArea_5year(:,3:end))',sum(IrrWUI_5year(:,3:end))',...
                               sum(IndGVA_5year(:,3:end))',sum(IndWUI_5year(:,3:end))',sum(Pop_5year(:,3:end))',sum(DomesticWUI_5year(:,3:end))'] )]);

