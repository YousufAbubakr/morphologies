%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grace O'Connell Biomechanics Lab, UC Berkeley Department of Mechanical
% Engineering - Etchverry 2162
%
% Processing disc geometry measurement data and computing bulk statistics 
% across control/kyphotic + regions of interest experimental groups.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

set(0,'DefaultFigureWindowStyle','docked')
set(groot, 'defaultAxesFontName', 'Times New Roman', ...
            'defaultTextFontName', 'Times New Roman', ...
            'defaultAxesFontSize', 12);
warning('off','all')

%% Importing segmentation measurement data
% Unless otherwise stated, dimensions are in mm

% path of the segmentation measurement data:
folderPath = "C:\Users\16233\Desktop\grad\projects\scoliosis\subject measurements\matlabSOPs\spineSOP\measurement files";

% loading all measurement data:
direcPath = dir(fullfile(folderPath, '*.mat'));
for i = 1:length(direcPath)
    baseFileName = direcPath(i).name;
    fullFileName = fullfile(folderPath, baseFileName);

    load(fullFileName) % loading .mat file
end

% keeping everything except measurement data:
clearvars -except discWedges discLevelNames subjects volDiscs surfareaDiscs ...
                    areaDiscInfs areaDiscSups

%% Partitioning data into experimental groups
% Cell data arrays are in general 3D, where the first indexing dimension,
% data{ii}, refers to the porcine subject according to the following convention:
%   ii = {1 --> 643c,
%           2 --> 658k,
%           3 --> 665k,
%           4 --> 723c,
%           5 --> 735c,
%           6 --> 764c,
%           7 --> 765k,
%           8 --> 766k,
%           9 --> 778c}
% The second indexing dimension, data{ii}{jj}, refers to the disc level
% jj of subject ii, where jj = [1, 2, ..., # of disc lvls in ii]. The third
% indexing dimension is used for measurements of n > 1 dimensions (like
% area and height, which area measured at various locations).

% disc spinal positions (regions of interest) partition:
all_level_names = {'T1-T2', 'T2-T3', 'T3-T4', 'T4-T5', 'T5-T6', 'T6-T7', 'T7-T8', ...
                    'T8-T9', 'T9-T10', 'T10-T11', 'T11-T12', 'T12-T13', 'T13-T14', 'T14-T15', ...
                    'T15-L1', 'L1-L2', 'L2-L3', 'L3-L4', 'L4-L5', 'L5-L6'};
ROIa_levels = {'T1-T2', 'T2-T3', 'T3-T4', 'T4-T5', 'T5-T6', 'T6-T7', 'T7-T8', ...
                'T8-T9', 'T9-T10', 'T10-T11', 'T11-T12', 'T12-T13', 'T13-T14', 'T14-T15'};
ROIb_levels = {'T15-L1', 'L1-L2', 'L2-L3', 'L3-L4', 'L4-L5', 'L5-L6'};
DisplayNameIa = 'thoracic';
DisplayNameIb = 'lumbar';
DisplayNameIIca = 'con, tho';
DisplayNameIIka = 'kyp, tho';
DisplayNameIIcb = 'con, lum';
DisplayNameIIkb = 'kyp, lum';

% control VS kyphotic partitioning processing:
iscontrol = cell(size(discLevelNames));
for ii = 1:length(discLevelNames)
    nlevels = length(discWedges{ii});
    iscontrol{ii} = cell(1, nlevels);
    for jj = 1:nlevels
        if contains(subjects{ii}, 'c')
            iscontrol{ii}{jj} = 1;
        elseif contains(subjects{ii}, 'k')
            iscontrol{ii}{jj} = 0;
        end
    end
end

% ROIs partitioning processing:
isROIa = cell(size(discLevelNames));
for ii = 1:length(discLevelNames)
    nlevels = length(discWedges{ii});
    isROIa{ii} = cell(1, nlevels);
    for jj = 1:nlevels
        if any(strcmp(ROIa_levels, discLevelNames{ii}{jj}))
            isROIa{ii}{jj} = 1;
        elseif any(strcmp(ROIb_levels, discLevelNames{ii}{jj}))
            isROIa{ii}{jj} = 0;
        end
    end
end

% porcine subjects overview:
ic = [1, 4, 5, 6, 9]; % indices of control porcine spines
ik = [2, 3, 7, 8]; % indices of kyphotic porcine spines
nsubjects = length(discLevelNames); % number of porcine subjects
ncontrols = length(ic); % number of control porcine subjects
nkyphotics = length(ik); % number of kyphotic porcine subjects

% porcine disc levels overview:
nca = 0; % # of control, ROIa segmentations
nka = 0; % # of kyphotic, ROIb segmentations
ncb = 0; % # of control, ROIa segmentations
nkb = 0; % # of kyphotic, ROIb segmentations
for ii = 1:nsubjects
    nlevels = length(discWedges{ii});
    for jj = 1:nlevels
        if iscontrol{ii}{jj} && isROIa{ii}{jj}
            nca = nca + 1;
        elseif ~iscontrol{ii}{jj} && isROIa{ii}{jj}
            nka = nka + 1;
        elseif iscontrol{ii}{jj} && ~isROIa{ii}{jj}
            ncb = ncb + 1;
        elseif ~iscontrol{ii}{jj} && ~isROIa{ii}{jj}
            nkb = nkb + 1;
        end
    end
end
ndisc_levels = nca + nka + ncb + nkb;
ncontrol_disc_levels = nca + ncb;
nkyphotic_disc_levels = nka + nkb;
nROIa_levels = nca + nka;
nROIb_levels = ncb + nkb;

% displaying results:
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
disp('Porcine subjects overview:')
disp('# of subjects: ' + string(nsubjects))
disp('# of control subjects: ' + string(ncontrols))
disp('# of kyphotic subjects: ' + string(nkyphotics))
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
disp('Porcine disc levels overview:')
disp('# of disc levels: ' + string(ndisc_levels))
disp('# of control levels: ' + string(ncontrol_disc_levels))
disp('# of kyphotic levels: ' + string(nkyphotic_disc_levels))
disp('# of ROIa levels: ' + string(nROIa_levels) + ' (control: ' + string(nca) + ', kyphotic: ' + string(nka) + ')')
disp('# of ROIb levels: ' + string(nROIb_levels) + ' (control: ' + string(ncb) + ', kyphotic: ' + string(nkb) + ')')
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')

%% Partitioning data into experimental groups wrt each disc level

% disc level proccessing
values = 1:length(all_level_names);
valuesa = 1:length(ROIa_levels);
valuesb = 1:length(ROIb_levels);
dict = containers.Map(all_level_names, values);
dicta = containers.Map(ROIa_levels, valuesa);
dictb = containers.Map(ROIb_levels, valuesb);

% bulk levels data properties:
nlevels_total = zeros(1, length(all_level_names)); % number of geometries associated w/ each level
nlevels_control = zeros(1, length(all_level_names)); % number of control geometries associated w/ each level
nlevels_kyphotic = zeros(1, length(all_level_names)); % number of kyphotic geometries associated w/ each level
for ii = 1:nsubjects
    nlevels = length(discWedges{ii});
    for jj = 1:nlevels
        I = dict(discLevelNames{ii}{jj});
        nlevels_total(I) = nlevels_total(I) + 1;
        if iscontrol{ii}{jj}
            nlevels_control(I) = nlevels_control(I) + 1;
        else
            nlevels_kyphotic(I) = nlevels_kyphotic(I) + 1;
        end
    end
end

%% Bulk statistics --> summary statistics
% Constructing and exporting (N x M) data arrays for all associated
% measurements to be used for summary statistics, where N refers to the #
% of curve samples associated with the given measurement and M refers to
% the sampling frequency

% summarizing 3D measurements:
Nlevels_ROIa = length(ROIa_levels);
Nlevels_ROIb = length(ROIb_levels);
wedge_ca_summary = zeros(min(nlevels_control), Nlevels_ROIa); % initializing disc wedging data array, control ROIa group
wedge_ka_summary = zeros(min(nlevels_kyphotic), Nlevels_ROIa); % initializing disc wedging data array, kyphotic ROIa group
wedge_cb_summary = zeros(min(nlevels_control), Nlevels_ROIb); % initializing disc wedging data array, control ROIb group
wedge_kb_summary = zeros(min(nlevels_kyphotic), Nlevels_ROIb); % initializing disc wedging data array, kyphotic ROIb group

vol_ca_summary = zeros(min(nlevels_control), Nlevels_ROIa); % initializing disc volume data array, control ROIa group
vol_ka_summary = zeros(min(nlevels_kyphotic), Nlevels_ROIa); % initializing disc volume data array, kyphotic ROIa group
vol_cb_summary = zeros(min(nlevels_control), Nlevels_ROIb); % initializing disc volume data array, control ROIb group
vol_kb_summary = zeros(min(nlevels_kyphotic), Nlevels_ROIb); % initializing disc volume data array, kyphotic ROIb group

sa_ca_summary = zeros(min(nlevels_control), Nlevels_ROIa); % initializing disc surface area data array, control ROIa group
sa_ka_summary = zeros(min(nlevels_kyphotic), Nlevels_ROIa); % initializing disc surface area data array, kyphotic ROIa group
sa_cb_summary = zeros(min(nlevels_control), Nlevels_ROIb); % initializing disc surface area data array, control ROIb group
sa_kb_summary = zeros(min(nlevels_kyphotic), Nlevels_ROIb); % initializing disc surface area data array, kyphotic ROIb group

saI_ca_summary = zeros(min(nlevels_control), Nlevels_ROIa); % initializing disc inferior surface area data array, control ROIa group
saI_ka_summary = zeros(min(nlevels_kyphotic), Nlevels_ROIa); % initializing disc inferior surface area data array, kyphotic ROIa group
saI_cb_summary = zeros(min(nlevels_control), Nlevels_ROIb); % initializing disc inferior surface area data array, control ROIb group
saI_kb_summary = zeros(min(nlevels_kyphotic), Nlevels_ROIb); % initializing disc inferior surface area data array, kyphotic ROIb group

saS_ca_summary = zeros(min(nlevels_control), Nlevels_ROIa); % initializing disc superior surface area data array, control ROIa group
saS_ka_summary = zeros(min(nlevels_kyphotic), Nlevels_ROIa); % initializing disc superior surface area data array, kyphotic ROIa group
saS_cb_summary = zeros(min(nlevels_control), Nlevels_ROIb); % initializing disc superior surface area data array, control ROIb group
saS_kb_summary = zeros(min(nlevels_kyphotic), Nlevels_ROIb); % initializing disc superior surface area data array, kyphotic ROIb group
for ii = 1:nsubjects
    nlevels = length(discWedges{ii});
    for jj = 1:nlevels
        if iscontrol{ii}{jj} && isROIa{ii}{jj}
            % appending control, ROIa disc data:
            Ia = dicta(discLevelNames{ii}{jj});
            Iwedgeca0 = find(wedge_ca_summary(:,Ia) == 0, 1, 'first');
            Ivolca0 = find(vol_ca_summary(:,Ia) == 0, 1, 'first');
            Isaca0 = find(sa_ca_summary(:,Ia) == 0, 1, 'first');
            IsaIca0 = find(saI_ca_summary(:,Ia) == 0, 1, 'first');
            IsaSca0 = find(saS_ca_summary(:,Ia) == 0, 1, 'first');

            if ~isempty(Iwedgeca0)
                wedge_ca_summary(Iwedgeca0, Ia) = discWedges{ii}{jj};
            end
            if ~isempty(Ivolca0)
                vol_ca_summary(Ivolca0, Ia) = volDiscs{ii}{jj};
            end
            if ~isempty(Isaca0)
                sa_ca_summary(Isaca0, Ia) = surfareaDiscs{ii}{jj};
            end
            if ~isempty(IsaIca0)
                saI_ca_summary(IsaIca0, Ia) = areaDiscInfs{ii}{jj};
            end
            if ~isempty(IsaSca0)
                saS_ca_summary(IsaSca0, Ia) = areaDiscSups{ii}{jj};
            end
        elseif ~iscontrol{ii}{jj} && isROIa{ii}{jj}
            % appending kyphotic, ROIa disc data:
            Ia = dicta(discLevelNames{ii}{jj});
            Iwedgeka0 = find(wedge_ka_summary(:,Ia) == 0, 1, 'first');
            Ivolka0 = find(vol_ka_summary(:,Ia) == 0, 1, 'first');
            Isaka0 = find(sa_ka_summary(:,Ia) == 0, 1, 'first');
            IsaIka0 = find(saI_ka_summary(:,Ia) == 0, 1, 'first');
            IsaSka0 = find(saS_ka_summary(:,Ia) == 0, 1, 'first');

            if ~isempty(Iwedgeka0)
                wedge_ka_summary(Iwedgeka0, Ia) = discWedges{ii}{jj};
            end
            if ~isempty(Ivolka0)
                vol_ka_summary(Ivolka0, Ia) = volDiscs{ii}{jj};
            end
            if ~isempty(Isaka0)
                sa_ka_summary(Isaka0, Ia) = surfareaDiscs{ii}{jj};
            end
            if ~isempty(IsaIka0)
                saI_ka_summary(IsaIka0, Ia) = areaDiscInfs{ii}{jj};
            end
            if ~isempty(IsaSka0)
                saS_ka_summary(IsaSka0, Ia) = areaDiscSups{ii}{jj};
            end
        elseif iscontrol{ii}{jj} && ~isROIa{ii}{jj}
            % appending control, ROIb disc data:
            Ib = dictb(discLevelNames{ii}{jj});
            Iwedgecb0 = find(wedge_cb_summary(:,Ib) == 0, 1, 'first');
            Ivolcb0 = find(vol_cb_summary(:,Ib) == 0, 1, 'first');
            Isacb0 = find(sa_cb_summary(:,Ib) == 0, 1, 'first');
            IsaIcb0 = find(saI_cb_summary(:,Ib) == 0, 1, 'first');
            IsaScb0 = find(saS_cb_summary(:,Ib) == 0, 1, 'first');

            if ~isempty(Iwedgecb0)
                wedge_cb_summary(Iwedgecb0, Ib) = discWedges{ii}{jj};
            end
            if ~isempty(Ivolcb0)
                vol_cb_summary(Ivolcb0, Ib) = volDiscs{ii}{jj};
            end
            if ~isempty(Isacb0)
                sa_cb_summary(Isacb0, Ib) = surfareaDiscs{ii}{jj};
            end
            if ~isempty(IsaIcb0)
                saI_cb_summary(IsaIcb0, Ib) = areaDiscInfs{ii}{jj};
            end
            if ~isempty(IsaScb0)
                saS_cb_summary(IsaScb0, Ib) = areaDiscSups{ii}{jj};
            end
        elseif ~iscontrol{ii}{jj} && ~isROIa{ii}{jj}
            % appending kyphtotic, ROIb disc data:
            Ib = dictb(discLevelNames{ii}{jj});
            Iwedgekb0 = find(wedge_kb_summary(:,Ib) == 0, 1, 'first');
            Ivolkb0 = find(vol_kb_summary(:,Ib) == 0, 1, 'first');
            Isakb0 = find(sa_kb_summary(:,Ib) == 0, 1, 'first');
            IsaIkb0 = find(saI_kb_summary(:,Ib) == 0, 1, 'first');
            IsaSkb0 = find(saS_kb_summary(:,Ib) == 0, 1, 'first');

            if ~isempty(Iwedgekb0)
                wedge_kb_summary(Iwedgekb0, Ib) = discWedges{ii}{jj};
            end
            if ~isempty(Ivolkb0)
                vol_kb_summary(Ivolkb0, Ib) = volDiscs{ii}{jj};
            end
            if ~isempty(Isakb0)
                sa_kb_summary(Isakb0, Ib) = surfareaDiscs{ii}{jj};
            end
            if ~isempty(IsaIkb0)
                saI_kb_summary(IsaIkb0, Ib) = areaDiscInfs{ii}{jj};
            end
            if ~isempty(IsaSkb0)
                saS_kb_summary(IsaSkb0, Ib) = areaDiscSups{ii}{jj};
            end
        end
    end
end

%% Exporting summary arrays

% exporting measurement summary arrays:
exportPath = "C:\Users\16233\Desktop\grad\projects\scoliosis\subject measurements\subject statistical modeling\disc measurement summaries";
filePath = append(exportPath, '\', 'summary_arrays.mat');
save(filePath, 'wedge_ca_summary', 'wedge_ka_summary', 'wedge_cb_summary', 'wedge_kb_summary', ...
                'vol_ca_summary', 'vol_ka_summary', 'vol_cb_summary', 'vol_kb_summary', ...
                'sa_ca_summary', 'sa_ka_summary', 'sa_cb_summary', 'sa_kb_summary', ...
                'saI_ca_summary', 'saI_ka_summary', 'saI_cb_summary', 'saI_kb_summary', ...
                'saS_ca_summary', 'saS_ka_summary', 'saS_cb_summary', 'saS_kb_summary', ...
                'ROIa_levels', 'ROIb_levels', 'DisplayNameIa', 'DisplayNameIb');
