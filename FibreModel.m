
%%
clc
    MatFiles = dir('*.mat');
    nfiles   = length(MatFiles);
   
    for iter = 1:nfiles
        mat     (iter) = load (MatFiles(iter).name);
        titles{1,iter} = MatFiles(iter).name(1:(end-4));
    end


%% %% Parameters
close all
clc
i=1; %trying AM (i=1)
DataRanks = [1 1 3 3 1]; % this is the rank of the specimen of the test group to be used

EpsM = [0.027 0.026 0.026 0.026 0.019 0.02];

E    = mat(i).E{1,DataRanks(i)}*1E6; %Pa%
%E    = 60E9;
SsM  = mat(i).Strength{1,DataRanks(i)}*1E6; %Pa
k    = -(log(SsM/(E*EpsM(i))))^-1;
TS_scale = k^(1/k) * EpsM(i) * E;
op = 1;
nFibres = 2600;
res(i).k = k;
res(i).s0 = TS_scale;

%%

[ res(i).Strain res(i).Force res(i).Stress res(i).cumulativeBF] = FibreBwbModel(E*ones(1,nFibres), nFibres, k , TS_scale, 14.6E-6, 'wbl');

%%
 [StrStr ax] = plotGQQ('Strain Stress',res(i).Strain, res(i).Stress*1E-6, 'Strain', 'Stress [MPa]');
    set(StrStr ,'Position',[800 100 650 400]);
    set(StrStr , 'PaperPositionMode', 'auto'); %to print file as seen in the screen
hold on
li = line(mat(i).strain{1,DataRanks(i)},mat(i).stress{1,DataRanks(i)},'linestyle','--','color',colorGQQ(1),'linewidth',1)
    
    
%%

for i = 2:6
    E    = mat(i).E{1,DataRanks(i)}*1E6; %Pa
    SsM  = mat(i).Strength{1,DataRanks(i)}*1E6; %Pa
    k    = -(log(SsM/(E*EpsM(i))))^-1;
    TS_scale = k^(1/k) * EpsM(i) * E;
    res(i).k = k;
    res(i).s0 = TS_scale;
    [ res(i).Strain res(i).Force res(i).Stress res(i).cumulativeBF] = FibreBwbModel(E*ones(1,nFibres), nFibres, k , TS_scale, 14.6E-6, 'wbl');
    lexp(i-1) = line(mat(i).strain{1,DataRanks(i)},mat(i).stress{1,DataRanks(i)},'linestyle','--','color',colorGQQ(i),'linewidth',2);
    lsim(i-1) = line(res(i).Strain, 1E-6 *  res(i).Stress,'color',colorGQQ(i),'linewidth',2);
end

%%
list1 = strcat({'AM','Dry','SW-RD','SW-Wet','W-RD','W-Wet'},'-Sim')
list2 = strcat({'AM','Dry','SW-RD','SW-Wet','W-RD','W-Wet'},'-Exp')
for i = 1:6
    list3(2*i-1)=list1(i);
    list3(2*i)  =list2(i);
end
%%
legend(list3)
ax.XLim = [0,0.08];
 print(StrStr,'Fit - model','-r300', '-dpng');
