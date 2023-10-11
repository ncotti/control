%% slblocks
% @brief: Allow custom library to be seen in the library browser of Simulink.
%  Called automatically by Matlab.
function blkStruct = slblocks

    % Name of the library
    Browser.Library = "MainLibrary";

    % Name to be displayed on the library browser
    Browser.Name = "Control Cotti";

    blkStruct.Browser = Browser;