clear all

% addpath ('C:/Users/gyourga/Documents/code/NiiStat-master/');
% addpath ('C:/Users/gyourga/Documents/code/spm12/');
% homepath = 'C:\Users\gyourga\Documents\code\predict_voxels';

addpath ('/home/gyourga/source/NiiStat-master/');
addpath ('/home/gyourga/source/spm12/');
homepath = '/home/gyourga/source/predict_voxels/gm_results';

for i = 1:213
    map_names{i} = ['z' num2str(i) '_map.nii'];
end
map_names{214} = 'r_map.nii';
map_names{215} = 'p_map.nii';

for j = 1:length (map_names)
    cd (homepath);
    map_name = map_names{j}
    combined_map = zeros ([121 145 121]);
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