%--------------------------------------------------------------------------
% INSTALL_ADMM_QP
% This scripts helps you get the ADMM QP Project up and running
%--------------------------------------------------------------------------
% 
%--------------------------------------------------------------------------
% Install script based on MFX Submission Install Utilities
% https://github.com/danielrherber/mfx-submission-install-utilities
% https://www.mathworks.com/matlabcentral/fileexchange/62651
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/admm-qp
%--------------------------------------------------------------------------
function INSTALL_ADMM_QP

	warning('off','MATLAB:dispatcher:nameConflict');

    % add contents to path
    AddSubmissionContents(mfilename)

    % download required web zips
    RequiredWebZips

    % add contents to path
    AddSubmissionContents(mfilename)

	% open an example
	OpenThisFile('ex_BrysonDenham')

	% close this file
	CloseThisFile(mfilename)
    
	warning('on','MATLAB:dispatcher:nameConflict');

end
%--------------------------------------------------------------------------
function RequiredWebZips
    disp('--- Obtaining required web zips')
    
    % initialize index
	ind = 0;

	ind = ind + 1;
	zips(ind).url = 'https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/27550/versions/3/download/zip/SparseNullOrth.zip';
	zips(ind).folder = 'MFX 27550';
	zips(ind).test = 'sporth';
    
	ind = ind + 1;
	zips(ind).url = 'https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/25453/versions/6/download/zip/PseudoInverseFolder.zip';
	zips(ind).folder = 'MFX 25453';
	zips(ind).test = 'pseudoinverse';
    
	ind = ind + 1;
	zips(ind).url = 'http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/40397/versions/7/download/zip/mfoldername_v2.zip';
	zips(ind).folder = 'MFX 40397';
	zips(ind).test = 'mfoldername';    

    % obtain full function path
    full_fun_path = which(mfilename('fullpath'));
    outputdir = fullfile(fileparts(full_fun_path),'include');

	% download and unzip
    DownloadWebZips(zips,outputdir)

	disp(' ')
end
%--------------------------------------------------------------------------
function AddSubmissionContents(name)
    disp('--- Adding submission contents to path')
    disp(' ')

    % current file
    fullfuncdir = which(name);

    % current folder 
    submissiondir = fullfile(fileparts(fullfuncdir));

    % add folders and subfolders to path
    addpath(genpath(submissiondir)) 
end
%--------------------------------------------------------------------------
function CloseThisFile(name)
    disp(['--- Closing ', name])
    disp(' ')

    % get editor information
    h = matlab.desktop.editor.getAll;

    % go through all open files in the editor
    for k = 1:numel(h)
        % check if this is the file
        if ~isempty(strfind(h(k).Filename,name))
            % close this file
            h(k).close
        end
    end
end
%--------------------------------------------------------------------------
function OpenThisFile(name)
    disp(['--- Opening ', name])

    try
        % open the file
        open(name);
    catch % error
        disp(['Could not open ', name])
    end

    disp(' ')
end
%--------------------------------------------------------------------------
function DownloadWebZips(zips,outputdir)

    % store the current directory
    olddir = pwd;
    
    % create a folder for outputdir
    if ~exist(outputdir, 'dir')
        mkdir(outputdir); % create the folder
    else
        addpath(genpath(outputdir)); % add folders and subfolders to path
    end
    
    % change to the output directory
    cd(outputdir)

    % go through each zip
    for k = 1:length(zips)

        % get data
        url = zips(k).url;
        folder = zips(k).folder;
        test = zips(k).test;

        % first check if the test file is in the path
        if exist(test,'file') == 0

            try
                % download zip file
                zipname = websave(folder,url);

                % save location
                outputdirname = fullfile(outputdir,folder);

                % create a folder utilizing name as the foldername name
                if ~exist(outputdirname, 'dir')
                    mkdir(outputdirname);
                end

                % unzip the zip
                unzip(zipname,outputdirname);

                % delete the zip file
                delete([folder,'.zip'])

                % output to the command window
                disp(['Downloaded and unzipped ',folder])
            
            catch % failed to download
                % output to the command window
                disp(['Failed to download ',folder])
                
                % remove the html file
                delete([folder,'.html'])
                
            end
            
        else
            % output to the command window
            disp(['Already available ',folder])
        end
    end
    
    % change back to the original directory
    cd(olddir)
end