close all; clear all; clc;
% addpath('07')


%% Derivative

load data_segment3.mat
numslices = 100;
tol = 30; % tolerance of dAdx considered close to linear (0)

i = 2; % 778C, 658K
j = 1; % T15 onwards


thissubj = subj(i);
thislevel = level(j);
A = squeeze(comp_areas(i,j,:));
y = squeeze(comp_heights(i,j,:));
dAdx = abs(gradient(A) ./ gradient(y));


% plot
figure
subplot(1,2,1)
hold on
plot(dAdx,y,'b','DisplayName','grad CSA')
plot(A,y,'DisplayName','CSA')
title(append(thissubj," ",thislevel))
ylabel('height')

%% Inferior surface?

% plot local max of CSA and grad CSA
TF = islocalmax(A);
plot(A(find(TF)),y(find(TF)),'*','DisplayName','max CSA')
yline(y(find(TF)),'k--','DisplayName','max CSA')
TF = islocalmax(dAdx);
plot(dAdx(find(TF)),y(find(TF)),'o','DisplayName','max grad CSA')
yline(y(find(TF)),'r--','DisplayName','max grad CSA')
TF = islocalmin(dAdx);
plot(dAdx(find(TF)),y(find(TF)),'o','DisplayName','min grad CSA')
yline(y(find(TF)),'m--','DisplayName','min grad CSA')


%% Inferior surface?

% firstly, we identify the local maxima of CSA curve and the local minima
% of dAdx (CSA's gradient) curve. these two are aligned.
% we need to find out if there are double humps.
% when double humps exist, the local maxima of CSA will point to the bigger
% hump which is further away from inferior/superior surface (closer to
% midsection).
% the smaller hump has its own local minima on dAdx curve. we make use of
% this.
% we go through each slice that are local minima of dAdx
% from the bottom up to the local maxima of CSA.
% if we identify a slice with value less than tolerance, then we flag that
% double humps exist. so we set that slice as the edge of inferior surface.
% conversely, if double humps do not exist, then the final slice (local
% maxima of CSA) is the edge of inferior surface.

TF_csa = islocalmax(A);
idx = find(TF_csa);
inf_segment = 1:idx(1); % slices belonging below first local max

TF_grad = islocalmin(dAdx);
isExist = false;

for i=1:idx(1)
    if ismember(i,find(TF_grad)) && dAdx(i) <= tol
        isExist = true;
        break
    end
end

if ~isExist
    i = idx(1);
end


subplot(1,2,2)
hold on
plot(dAdx,y,'b','DisplayName','grad CSA')
plot(A,y,'DisplayName','CSA')
title(append(thissubj," ",thislevel))
ylabel('height')
disp('Inferior index: ' + string(i))
yline(y(i),'k--')


%% Superior surface?

TF_csa = islocalmax(A);
idx = find(TF_csa);
sup_segment = idx(end):numslices; % slices belonging above last local max

TF_grad = islocalmin(dAdx);
isExist = false;

for i=numslices:-1:idx(end)
    if ismember(i,find(TF_grad)) && dAdx(i) <= tol
        isExist = true;
        break
    end
end

if ~isExist
    i = idx(end);
end


disp('Superior index: ' + string(i))
yline(y(i),'k--')
legend

