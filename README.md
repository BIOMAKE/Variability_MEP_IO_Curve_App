# A user-friendly input-output curve analysis for neuromodulation, such as transcranial magnetic stimulation and electrical stimulation

## Background
The high response variability has become a key topic in brain stimulation. One example that demonstrates high variability is motor-evoked potentials (MEPs). MEPs are among the few readily observable direct responses to suprathreshold stimuli, e.g., of transcranial magnetic stimulation, and serve for a variety of applications, often in the form of dose-response curves, also called recruitment or input-output (IO) curves. However, MEPs and thus IO curves show extreme trial-to-trial variability that can exceed more than two decimal orders of magnitude. Recent studies have identified issues in previous statistical analysis of IO curves and introduced better methods, others could quantitatively separate several widely independent variability sources. However, research has failed to provide the field with a user-friendly implementation of the methods for analysing such IO curves statistically sound and separating variability so that they were limited to a few groups. 


This work intends to provide the latest methods for analysing IO curves and extracting variability information in an open-source package so that the community can easily use and adapt them to their own needs. We implemented recent IO curve methods with a graphical user interface in the MATLAB App Designer and provided the code as well as compiled versions for Mac, Linux, and Windows. The application imports typical IO data of individual stimulus-response sets, guides users step by step through the analysis, and allows exporting of the results including figures for post-hoc analysis and documentation, catering to the needs of clinical and experimental neuroscientists.


## Introduction
The code implements a stand-alone user-friendly app that can analyse the variability of MEP IO curves for individual subjects and larger subject populations with their trail-to-trail variability. The whole project is implemented in MATLAB (R2022b) and uses object-oriented programming. In this repository, `SampleCode.m` provides a basic introduction to code usage. More detailed instructions can be found inside the code. Moreover, a built-in instruction programme is also provided in this app. We also provide a sample database `mySamplePoints.xlsx` for users to get familiar with how the app or code works.


## Folder: StandaloneApp_v10
This folder contains three app installers for Mac, Linux, and Windows. `MATLAB Runtime(R2022B)` is pre-required to install this MATLAB app. MATLAB® Runtime contains the libraries needed to run compiled MATLAB applications on a target system without a licensed copy of MATLAB.


## Folder: Development
All source files are provided in this folder.
1. `modelCalibration.m`: This class provides three optimisation algorithms to calibrate the provided model.
2. `Hill5PCurveModel.m`: This is the main model class, modified from the original code given in Reference 1.
3. `figureOperation.m`: This class is to plot figures, such as the logarithmic MEP IO curve with variability ranges, and the excitability level plot and its corresponding p-value histogram.
4. `tableOperation.m`: This class is used in the app and provides static methods to update the content of the GUI table.
5. `saveFileOperation.m`: This class is used in the app and is to save plots and optimal results.

## References
1. Goetz SM, Peterchev AV. A model of variability in brain stimulation evoked responses. In 2012 Annual International Conference of the IEEE Engineering in Medicine and Biology Society 2012 Aug 28 (pp. 6434-6437). IEEE.
2. Goetz SM, Luber B, Lisanby SH, Peterchev AV. A novel model incorporating two variability sources for describing motor evoked potentials. Brain stimulation. 2014 Jul 1;7(4):541-52.
3. Goetz SM, Howell B, Wang B, Li Z, Sommer MA, Peterchev AV, Grill WM. Isolating two sources of variability of subcortical stimulation to quantify fluctuations of corticospinal tract excitability. Clinical Neurophysiology. 2022 Jun 1;138:134-42.
