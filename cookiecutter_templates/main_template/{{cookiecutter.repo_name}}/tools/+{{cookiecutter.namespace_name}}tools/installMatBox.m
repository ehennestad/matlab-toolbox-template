function installMatBox(mode)
% installMatBox - Bootstrap MatBox using the matbox-actions installer.

    arguments
        mode (1,1) string {mustBeMember(mode, ["release", "commit"])} = "release"
    end

    if exist("+matbox/installRequirements", "file") == 2
        return
    end

    % Fetch the installer from the v1 release tag, not main: v1 only moves
    % when matbox-actions publishes a release, so local installs get gated,
    % release-quality updates instead of whatever is currently on main.
    sourceFile = "https://raw.githubusercontent.com/ehennestad/matbox-actions/refs/tags/v1/install-matbox/installMatBox.m";

    tempFolder = tempname;
    mkdir(tempFolder)
    cleanupObj = onCleanup(@() rmdir(tempFolder, "s"));

    websave(fullfile(tempFolder, "installMatBox.m"), sourceFile);

    oldPath = addpath(tempFolder, "-begin");
    pathCleanupObj = onCleanup(@() path(oldPath));

    rehash()
    installMatBox(mode)
    rehash()
end
