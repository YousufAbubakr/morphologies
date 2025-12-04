%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grace O'Connell Biomechanics Lab, UC Berkeley Department of Mechanical
% Engineering - Etchverry 2162
%
% Comparing AP height measurements between MATLAB and 3D Slicer stl export
% files (which are measured in SolidWorks).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc

set(0,'DefaultFigureWindowStyle','docked')

%% Constructing Validation Sets
% Unless otherwise stated, dimensions are in mm

% Validation subjects + levels:
validation_1 = {'658', 'T2'};
validation_2 = {'778', 'T14'};
validation_3 = {'778', 'T15'};
validation_4 = {'658', 'T13'};
validation_5 = {'778', 'L5'};
validation_6 = {'778', 'T2'};
validation_sets = {validation_1, ...
                    validation_2, ...
                    validation_3, ...
                    validation_4, ...
                    validation_5, ...
                    validation_6};
nsets = length(validation_sets);

%% MATLAB Measurements

h_mats = zeros(nsets, nh); % MATLAB-measured height measurements
y_mats = zeros(nsets, nh); % MATLAB-measured AP position measurements
subjectLabels = cell(length(subjects), 1); % getting labels of 
for h = 1:length(subjects)
    subjectLabels{h} = subjects{h}(1:end-1);
end
for k = 1:nsets
    validation_set = validation_sets{k};
    s = validation_set{1}; % validation set subject
    l = validation_set{2}; % validation set level

    I_s = find(strcmp(subjectLabels, s)); % index of s in subjects
    I_l = find(strcmp(levels{I_s}, l)); % index of l in levels

    h_mats(k,:) = squeeze(hAPs{I_s}{I_l}); % MATLAB-measured height
    y_mats(k,:) = squeeze(yAPs{I_s}{I_l}); % MATLAB-measured AP position
end

%% SolidWorks Measurements
% Anterior = 0 AP Position, posterior > 0 AP Position

sw_measurements = readmatrix("C:\Users\16233\Desktop\grad\projects\scoliosis\subject measurements\matlabSOPs\heightValidaiton\SolidWorks Measurements _ Height Measurement Validations - Height.csv");
sw_measurements = sw_measurements(4:end,:); % removing header cells

h_solids = cell(nsets, 1); % SW-measured height measurements
y_solids = cell(nsets, 1); % SW-measured AP position measurements

% solidworks measurements:
for k = 1:nsets
    h_s = sw_measurements(:,2*k-1);
    y_s = sw_measurements(:,2*k);
    h_s = h_s(~isnan(h_s));
    y_s = y_s(~isnan(y_s));

    h_solids{k} = h_s;
    y_solids{k} = y_s;
end

%% Comparing Measurements

% storing errors:
mean_errs = zeros(1, nsets);

figure
sgtitle('Comparing AP height distribution measurements')
for k = 1:nsets
    subplot(1,nsets,k);
    hold on 

    validation_set = validation_sets{k};
    s = validation_set{1}; % validation set subject
    l = validation_set{2}; % validation set level

    h_mat = h_mats(k,:);
    h_solid = h_solids{k};

    y_mat = y_mats(k,:);
    y_solid = y_solids{k};

    % interpolation:
    h_mat_pred = interp1(y_solid, h_solid, y_mat); % interpolated version of solidworks measurement
    h_mat_pred = h_mat_pred(~isnan(h_mat_pred));
    h_mat = h_mat(~isnan(h_mat_pred));
    y_mat = y_mat(~isnan(h_mat_pred));

    % using middle m% of data to measure error:
    nnn = length(h_mat_pred);
    ppp = 1;
    num_to_keep = round(ppp * nnn);
    num_to_remove = nnn - num_to_keep;
    start_idx = floor(num_to_remove/2) + 1;
    end_idx = start_idx + num_to_keep - 1;

    % measuring error:
    err = h_mat_pred(start_idx:end_idx) - h_mat(start_idx:end_idx); % error 
    abs_err = abs(err); % absolute error 
    relerr = abs_err./h_mat_pred(start_idx:end_idx); % relative error (solidworks is ground truth)
    pererr = relerr * 100; % percentage error
    max_err = max(pererr);
    mean_err = mean(pererr);
    mean_errs(k) = mean_err;
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    disp('Errors for: ' + string(s) + ', ' + string(l))
    disp('Max percentage error (%): ' + string(max_err))
    disp('Mean percentage error (%): ' + string(mean_err))
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')

    plot(h_mat, y_mat)
    plot(h_solid, y_solid)
    xlabel('sup-inf height [mm]')
    ylabel('position along AP [mm]')
    title(string(s) + ', ' + string(l))
    ylim([0 max(y_mat)])
    legend('MATLAB', 'SolidWorks')
end
disp('Net mean percentage error (%): ' + string(mean(mean_errs)))


