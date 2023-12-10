# MEP_IO_Curve_App

## Background
The high response variability has become a key topic in brain stimulation. One example that demonstrates high variability is motor-evoked potentials (MEPs). MEPs are among the few readily observable direct responses to suprathreshold stimuli, e.g., of transcranial magnetic stimulation, and serve for a variety of applications, often in the form of dose-response curves, also called recruitment or input-output (IO) curves. However, MEPs and thus IO curves show extreme trial-to-trial variability that can exceed more than two decimal orders of magnitude. Recent studies have identified issues in previous statistical analysis of IO curves and introduced better methods, others could quantitatively separate several widely independent variability sources. However, research has failed to provide the field with a user-friendly implementation of the methods for analysing such IO curves statistically sound and separating variability so that they were limited to a few groups. We implemented recent IO curve methods with a graphical user interface in the MATLAB App Designer and provided the code as well as compiled versions for Mac, Linux, and Windows.


## Introduction
The code implements a stand-alone user-friendly app that can analyse the variability of MEP IO curves for individual subjects and larger subject populations with their trail-to-trail variability. The whole project is implemented in MATLAB (R2022b) and uses object-oriented programming. In this repository, `SampleCode.m` provides a basic introduction to code usage. More detailed instructions can be found inside the code. Moreover, a built-in instruction programme is also provided in this app.


## Folder: Functions
1. `modelCalibration.m`: This class provides three optimisation algorithms to calibrate the provided model.
2. `Hill5PCurveModel.m`: This is the main model class, modified from the original code in the study of 'Goetz SM, Peterchev AV. A model of variability in brain stimulation evoked responses. In 2012 Annual International Conference of the IEEE Engineering in Medicine and Biology Society 2012 Aug 28 (pp. 6434-6437). IEEE.'.
3. `figureOperation.m`: This class is to plot figures, such as the logarithmic MEP IO curve with variability ranges, and the excitability level plot and its corresponding p-value histogram.
4. `tableOperation.m`: This class is used in the app and provides static methods to update the content of the GUI table.
5. `saveFileOperation.m`: This class is used in the app and is to save plots and optimal results.
