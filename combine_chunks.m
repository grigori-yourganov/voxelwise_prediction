clear all

% Please set this variable to the path to the chunk-specific folders
homepath = '/home/gyourga/source/predict_voxels/i3mT1_results';

% if necessary, add the paths to NiiStat and spm12 here
% addpath ('C:/Users/gyourga/Documents/code/NiiStat-master/');
% addpath ('C:/Users/gyourga/Documents/code/spm12/');

% addpath ('/home/gyourga/source/NiiStat-master/');
% addpath ('/home/gyourga/source/spm12/');

cd ([homepath '/chunk1']);
zdir = dir ('z*_map.nii');
nz = length(zdir);
for i = 1:nz
    map_names{i} = ['z' num2str(i) '_map.nii'];
end
map_names{nz+1} = 'r_map.nii';
map_names{nz+2} = 'p_map.nii';

for j = 1:length (map_names)
    cd (homepath);
    map_name = map_names{j}
    combined_map = zeros ([105 127 91]);
    for i = 1:8
        cd (['chunk' num2str(i)]);
        hdr = spm_vol (map_name);
        chunk = spm_read_vols (hdr);
        combined_map = combined_map + chunk;
        cd (homepath);
    end
    
    cd (homepath);
    mkdir ('combined');
    cd ('combined');
    hdr.fname = [pwd '/' map_name];
    spm_write_vol (hdr, combined_map);
end
