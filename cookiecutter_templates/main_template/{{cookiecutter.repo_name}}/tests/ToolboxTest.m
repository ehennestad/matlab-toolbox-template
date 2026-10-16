classdef ToolboxTest <  matlab.unittest.TestCase
% ToolboxTest - Unit test for testing the toolbox functions.


    methods (Test)
        function testToolboxDir(testCase)
            pathStr = {{cookiecutter.namespace_name}}.toolboxdir();
            testCase.verifyClass(pathStr, 'char')
            testCase.verifyTrue(isfolder(pathStr))
        end

        function testToolboxVersion(testCase)
            versionStr = {{cookiecutter.namespace_name}}.toolboxversion();
            testCase.verifyClass(versionStr, 'char')
            testCase.verifyMatches(versionStr, '^\d+\.\d+\.\d+(\.\d+)?$')
        end

        function testGettingStartedFindsExamplesFolder(testCase)
            output = evalc('{{cookiecutter.namespace_name}}.gettingStarted()');
            testCase.verifyFalse(contains(output, 'Examples directory not found'))
        end
    end
end
