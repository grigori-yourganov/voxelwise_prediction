clear all
% specify these variables:
% the exact name of the voxelwise modality ('i3mT1', 'fa', 'md', etc)
modality = 'i3mT1';
% the path to the MAT files
path = 'C:\Users\gyourga\Documents\data\POLAR_FIRST_SESSION_ONLY_MAT_FILES';

warning ('off', 'MATLAB:unknownElementsNowStruc');
cd (path);
d = dir ('M1*1.mat');
idx = 1;
hdr = [];
for i = 1:length (d)
    l = load (d(i).name);
    if isfield (l, modality)
        neurodata (:, :, :, idx) = l.i3mT1.dat;
        subj_name{idx} = d(i).name;
        if isempty (hdr)
            hdr = l.i3mT1.hdr;
        end
        idx = idx + 1;
    else
        disp ([d(i).name ' does not have ' modality]);
    end
end

save ([modality '.mat'], 'neurodata', 'subj_name', 'hdr');