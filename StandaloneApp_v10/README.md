# StandaloneApp_v10
This folder contains three app installers for Mac, Linux, and Windows. `MATLAB Runtime(R2022B)` is pre-required to install this MATLAB app. MATLAB® Runtime contains the libraries needed to run compiled MATLAB applications on a target system without a licensed copy of MATLAB.


## Folder: Source
All source files are provided in this folder.
In `Functions` folder:
    1. `modelCalibration.m`: This class provides three optimisation algorithms to calibrate the provided model.
    2. `Hill5PCurveModel.m`: This is the main model class, modified from the original code given in Reference 1.
    3. `figureOperation.m`: This class is to plot figures, such as the logarithmic MEP IO curve with variability ranges, and the excitability level plot and its corresponding p-value histogram.
    4. `tableOperation.m`: This class is used in the app and provides static methods to update the content of the GUI table.
    5. `saveFileOperation.m`: This class is used in the app and is to save plots and optimal results.
