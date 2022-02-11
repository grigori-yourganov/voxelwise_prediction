clear all
% specify these variables:
% the exact name of the voxelwise modality ('i3mT1', 'fa', 'md', etc)
modality = 'fa';
% the path to the MAT files
path = 'C:\Users\gyourga\Documents\data\POLAR_FIRST_SESSION_ONLY_MAT_FILES';
% the paths to NiiStat and SPM
addpath ('C:/Users/gyourga/Documents/code/NiiStat-master/');
addpath ('C:/Users/gyourga/Documents/code/spm12/');

warning ('off', 'MATLAB:unknownElementsNowStruc');
cd (path);
d = dir ('M1*1.mat');
idx = 1;
hdr = [];
for i = 1:length (d)
    l = load (d(i).name);
    if isfield (l, modality)
        if isempty (hdr)
           % first subject will provide the reference header
           hdr = l.(modality).hdr;
           neurodata (:, :, :, idx) = l.(modality).dat;
        else
           if sum (hdr.dim ~= l.(modality).hdr.dim) == 0 % no need to reslice
               neurodata (:, :, :, idx) = l.(modality).dat;
           else % need to reslice to the first subject
               [new_hdr, new_dat] = nii_reslice_target(l.(modality).hdr, l.(modality).dat, hdr); 
               neurodata (:, :, :, idx) = new_dat;
           end
        end
        
        subj_name{idx} = d(i).name;

        idx = idx + 1;
    else
        disp ([d(i).name ' does not have ' modality]);
    end
end

save ([modality '.mat'], 'neurodata', 'subj_name', 'hdr', '-v7.3');
