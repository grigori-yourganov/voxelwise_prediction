% this function predicts the voxelwise neuroimaging modality from the behaviour files.
% arguments: 
% chunk_idx -- the number of the brain chunk (see below);
% in_file -- the name of the file containing neurpimaging data;
% out_rootfolder -- the name of the output folder (the process will create
%                   a subfolder inside the out_rootfolder for the specified chunk)
% behav_filename -- the name of the Excel spreadsheet with behavioural data
%    (must contain a sheet called "to_analyze")
%
% example:
% process_chunk (1, 'i3mT1.mat', 'i3mT1_results', 'baseline_imputed.xlsx')

% the argument is the number of the chunk:
% 0: process whole brain
% 1: bottom back right; 2: bottom back left;
% 3: bottom front right; 4: bottom front left;
% 5: top back right; 6: top back left;
% 7: top front right; 8: top front left.

function process_chunk (chunk_idx, in_file, out_rootfolder, behav_filename)

%addpath ('C:/Users/gyourga/Documents/code/NiiStat-master/');
%addpath ('C:/Users/gyourga/Documents/code/spm12/');
%addpath ('/home/gyourga/source/NiiStat-master/');
%addpath ('/home/gyourga/source/spm12/');

out_folder = [out_rootfolder '/chunk' num2str(chunk_idx)];
load (in_file);
dim_x = hdr.dim(1); dim_y = hdr.dim(2); dim_z = hdr.dim(3);
halfdim_x = round(dim_x/2); halfdim_y = round(dim_y/2); halfdim_z = round(dim_z/2);

if chunk_idx == 0
  cutout_x = []; cutout_y = []; cutout_z = [];
elseif chunk_idx == 1
  cutout_x = 1:halfdim_x; cutout_y = 1:halfdim_y; cutout_z = 1:halfdim_z;
elseif chunk_idx == 2
  cutout_x = halfdim_x+1:dim_x; cutout_y = 1:halfdim_y; cutout_z = 1:halfdim_z;
elseif chunk_idx == 3
  cutout_x = 1:halfdim_x; cutout_y = halfdim_y+1:dim_y; cutout_z = 1:halfdim_z;
elseif chunk_idx == 4
  cutout_x = halfdim_x+1:dim_x; cutout_y = halfdim_y+1:dim_y; cutout_z =1:halfdim_z;
elseif chunk_idx == 5
  cutout_x = 1:halfdim_x; cutout_y = 1:halfdim_y; cutout_z = halfdim_z+1:dim_z;
elseif chunk_idx == 6
  cutout_x = halfdim_x+1:dim_x; cutout_y = 1:halfdim_y; cutout_z = halfdim_z+1:dim_z;
elseif chunk_idx == 7
  cutout_x = 1:halfdim_x; cutout_y = halfdim_y+1:dim_y; cutout_z = halfdim_z+1:dim_z;
elseif chunk_idx == 8
  cutout_x = halfdim_x+1:dim_x; cutout_y = halfdim_y+1:dim_y; cutout_z = halfdim_z+1:dim_z;
end

[num, txt, raw] = xlsread (behav_filename, 'to_analyze');

beh = nan(size(num, 2)-1, length(subj_name));

for i = 1:length (subj_name)
    str = subj_name{i};
    subj_no = str2num (str (2:5));
    idx = find (num(:, 1) == subj_no);
    beh(:, i) = num (idx, 2:size(num, 2));    
end

invalid_idx = union (find (var (beh, 0, 2) == 0), find (isnan (var (beh, 0, 2))));
beh (invalid_idx, :) = [];

ss = sum (neurodata, 4);
good_idx = find (~isnan (ss));

%cut out a part for further analysis
[mesh_x, mesh_y, mesh_z] = meshgrid (cutout_x, cutout_y, cutout_z);
cutout_idx = sub2ind (size (ss), mesh_x(:), mesh_y(:), mesh_z(:));
good_idx = intersect (good_idx, cutout_idx);

[xx, yy, zz] = ind2sub (size (ss), good_idx);
rmap = zeros (size (ss));
pmap = zeros (size (ss));
zmap = zeros ([size(ss) size(beh,1)]);
for i = 1:length (good_idx)
    vox = squeeze (neurodata (xx(i), yy(i), zz(i), :));
    [r, z, pred, p] = svr_core (beh', vox, '', 0);
    rmap(xx(i), yy(i), zz(i)) = r;
    pmap(xx(i), yy(i), zz(i)) = p;
    zmap(xx(i), yy(i), zz(i), :) = z;
end

mkdir (out_folder);
cd (out_folder);
hdr.fname = 'r_map.nii';
spm_write_vol (hdr, rmap);
hdr.fname = 'p_map.nii';
spm_write_vol (hdr, pmap);
for j = 1:size (zmap, 4)
    hdr.fname = ['z' num2str(j) '_map.nii'];
    spm_write_vol (hdr, squeeze (zmap (:, :, :, j)));
end
