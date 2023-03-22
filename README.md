<h1>Continuous Integration for Verification of Simulink® Models Using GitLab</h1>

This project is used in the explanation of the Technical Article ['Continuous Integration for Verification of Simulink® Models Using GitLab®'](https://www.mathworks.com/company/newsletters/articles/continuous-integration-for-verification-of-simulink-models-using-gitlab.html) to describe a simple end-to-end example showing Model Based Design integration into GitLab®. Upon following the steps in the Technical Article, one can setup a running Continuous Integration pipeline performing verify, build, test and package stages to generate corresponding artifacts.



Quick Start guide
==================
1. Fork the repository to your own GitHub® account.
2. Setup the GitLab® Runner, as outlined in the Technical Article.
3. Create a new CI job using your forked repository.

Please refer the Technical Article 'Continuous Integration for Verification of Simulink Models Using GitLab' for detailed instructions on how to setup and run the continuous integration pipeline.



Folder Structure
================

### Top-level directory layout

    .
    ├── Data                                        # Data required to run the models and test cases.
    ├── Design                                      # This folder consists of sub-folders for each of the models in Cruise Control System.
    ├── Requirements                                # Requirements for the Cruise Control System.
    ├── tools                                       # Consists of files which can be useful while working with the models.
    │   ├── help                                    # Contains files which describe the Cruise Control System and its behaviour.
    │   ├── utilities                               # Consists of scripts and functions which are used for running the models.
    ├── .gitlab-ci.yml                              # Contains the stages to run in the parent pipeline and definitions for the child pipelines.
    ├── .driverSwRequest-gitlab-ci.yml              # Contains the stages to run in the child pipeline for the model 'DriverSwRequest'.
    ├── .cruiseControlMode-gitlab-ci.yml            # Contains the stages to run in the child pipeline for the model 'CruiseControlMode'.
    ├── .targetSpeedThrottle-gitlab-ci.yml          # Contains the stages to run in the child pipeline for the model 'TargetSpeedThrottle'.
    ├── .crs_controller-gitlab-ci.yml               # Contains the stages to run in the child pipeline for the model 'crs_controller'.
    ├── CruiseControlExample.prj                    # Can run this file in MATLAB® to setup the Simulink project
    ├── LICENSE
    ├── SECURITY.md
    └── README.md

### Design files
The Design folder consists of sub-folders for each of the models in the Cruise Control System.

The models are:
1. crs_controller
2. CruiseControlMode
3. DriverSwRequest
4. TargetSpeedThrottle

Each model folder consists of:

    .
    ├── ...
    ├── Design
    │   ├── crs_controller
    │   │   ├── ...
    │   ├── CruiseControlMode
    │   │   ├── ...
    │   ├── DriverSwRequest
    │   │   ├── pipeline                 # Contains files related to 'DriverSwRequest' model's child pipeline.
    │   │   │   ├── analyze              # Contains artifacts corresponding to different stages in the executed pipeline.
    │   │   │   │   ├── verify           # Contains generated Model Advisor Report.
    │   │   │   │   ├── build            # Contains generated Build Report.
    │   │   │   │   ├── testing          # Contains generated Test Result Reports.
    │   │   │   │   ├── package          # Contains generated Summary Report which is a summary of all the results from the previous stages.
    │   │   │   ├── build                # Contains scripts to build the model.
    │   │   │   ├── tests                # Contains scripts to run unit tests on the model.
    │   │   │   ├── verify               # Contains scripts to run Model Advisor using ISO26262 checks on the model.
    │   │   ├── specification            # Contains the Simulink®  Model file.
    │   ├── TargetSpeedThrottle
    │   │   ├── ...
    └── ...


### Tools and Utilities

    .
    ├── ...
    ├── tools
    │   ├── ...
    │   ├── utilities
    │   │   ├── config_data
    │   │   │   ├── iso26262Checks.json              # The configuration file containing the Model Advisor Checks.
    │   │   ├── pipeline_functions                   # Contains those scripts which are used for running the pipeline.
    │   │   │   ├── deleteLogs.m                     # Deletes the logs generated while running the verify, build , test stages in the pipeline.
    │   │   │   ├── generateHTMLReport.m             # Generates the HTML Summary report for a specified model.
    │   │   │   ├── generateXMLFromLogs.m            # Generates a single XML file containg the results from the verify, build, test stages of the pipeline.
    │   │   │   ├── modelAdvisorAction.m             # Runs the Model Advisor Checks for a specified model.
    │   │   │   ├── modelBuildAction.m               # Script to build the model.
    │   │   │   ├── modelTestsAction.m               # Runs the unit tests for the specified model.
    │   │   │   ├── report.xsl                       # Template of the Summary Report that gets generated in the Package stage of the pipeline.
    │   │   │   ├── runFolderTests.m                 # Runs the scripts in a specified folder for a specified model.
    │   │   ├── setup
    │   │   │   ├── cleanUp.m                        # Can be used to run at the end to remove generated files and folders.
    │   │   │   ├── startUp.m                        # Configured to run on Project startup and can be used to modify locations where Simulink® Cache files and codegen folders are generated.
    │   │   ├── user_scripts
    │   │   │   ├── openModels.m                     # Opens all the models
    │   │   │   ├── runAllTestsLocally.m             # Used for locally running all the scripts used in various stages of pipeline and can be run before pushing to remote.
    └── ...



Products/Toolboxes Required
===========================
This project works on MATLAB 2020b, 2021a.
- [MATLAB®](https://www.mathworks.com/products/matlab.html)
- [Simulink®](https://www.mathworks.com/products/simulink.html)
- [Embedded Coder®](https://www.mathworks.com/products/embedded-coder.html)
- [MATLAB® Coder™](https://www.mathworks.com/products/matlab-coder.html)
- [Simulink® Check™](https://www.mathworks.com/products/simulink-check.html)
- [Simulink® Coder™](https://www.mathworks.com/products/simulink-coder.html)
- [Simulink® Coverage™](https://www.mathworks.com/products/simulink-coverage.html)
- [Simulink Requirements™](https://www.mathworks.com/products/requirements-toolbox.html)
- [Simulink® Test™](https://www.mathworks.com/products/simulink-test.html)
- [Stateflow®](https://www.mathworks.com/products/stateflow.html)
- [Supported and Compatible Compilers](https://www.mathworks.com/support/requirements/supported-compilers.html)



License
=======
The license for Continuous Integration for Verification of Simulink Models Using GitLab is available in the [license.txt](license.txt) file in this repository.



Community Support
=================
[MATLAB Central](https://www.mathworks.com/matlabcentral/)


Copyright 2021 The MathWorks, Inc.
