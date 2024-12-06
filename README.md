## **Time-multiplexed Sensor Signal Generation and Acquisition using LabView VIs**

This project was created while completing my PhD at Nanoengineered Systems Laboratory at UCL in order to bias up to 4 light sources and detect amplified time-multiplexed analog signal from multiple photodiodes. 

## **Introduction**

National Instrument data acquisition (DAQ) cards are a popular hardware tool for automation of various hardware components and I opted to use a DAQ card (USB-6363) to bias the light sources on the hybrid 3D-printed near-infrared spectroscopy-based oxygen sensors I was fabricating during my PhD. 

The different files in the repo serve the following purposes:

- [Simultaneous generation of analog voltage and digital signals.vi](https://github.com/mpetreikis/labview_time_multiplexing/blob/main/LabView%20VIs/Simultaneous%20generation%20of%20analog%20voltage%20and%20digital%20signals.vi) is a LabView virtual instrument (VI) used to bias between two and four analog outputs with a desired level of voltage (individually changed) while simultaneously biasing four digital outputs with waveforms that coincide with the analog waveforms in the time domain. The main idea behind this was that the digital signals generated, which would be read off using the next VI, could be used for demultiplexing of the signal recorded. The analog signals generated would be used in conjuction with voltage controlled-current sources to control the LED currents and, therefore, their brightness levels.
- [Simultaneous reading of analog and digital signals.vi](https://github.com/mpetreikis/labview_time_multiplexing/blob/main/LabView%20VIs/Simultaneous%20reading%20of%20analog%20and%20digital%20signals.vi) is a VI used to detect and record multiple analog and digital signals simultaneously. Once again, in my use case, the analog signals recorded corresponded to the amplified photocurrents generated when shining light on skin and some of it is reflected/scattered back. As the LED biasing was time-multiplexed, the recorded digital signals would allow demultiplexing of the recorded analog signals. Textboxes with comments regarding this principle of operation of this and the previous VI are provided within the VIs.
- [Get Terminal Name with Device Prefix.vi](https://github.com/mpetreikis/labview_time_multiplexing/blob/main/LabView%20VIs/Get%20Terminal%20Name%20with%20Device%20Prefix.vi) is a sub-VI needed to run the two VIs above.
- [tdmsToStruct.m](https://github.com/mpetreikis/labview_time_multiplexing/blob/main/Matlab%20code%20for%20TDMS%20files/tdmsToStruct.m), [structToJSON.m](https://github.com/mpetreikis/labview_time_multiplexing/blob/main/Matlab%20code%20for%20TDMS%20files/tdmsToJSON.m), and [tdmsToJSON.m](https://github.com/mpetreikis/labview_time_multiplexing/blob/main/Matlab%20code%20for%20TDMS%20files/tdmsToJSON.m) are Matlab scripts that I use to convert the data saved in LabView specific .tdms format to JSON files, so that it could be later processed in Python. **Read the next section to find out more about how to use these functions, they have dependencies.**

__N.B.__ In hindsight, this is a pretty expensive solution to buildng an experimental setup for operating those sensors as DAQ cards are not cheap, so something simpler, such as an Arduino board, might suffice.

## **Requirements and Usage**

1. For LabView VIs, LabView 2012 or newer is required
2. For Matlab functions, _TDMS Reader_ library from Matlab File Exchange ([link](https://www.mathworks.com/matlabcentral/fileexchange/30023-tdms-reader)) needs to be downloaded and inserted in the Matlab's path; R2010a release or newer is required
3. Modify LabView VIs and the Matlab function to your needs
4. Use the project as desired

## **Contributing**

If you'd like to contribute to this project, feel free to email me (mpetreikis@tutanota.com) or simply, fork the repo, create a new branch for your changes and eventually submit a pull request.

## **License**

**Time-multiplexed Sensor Signal Generation and Acquisition using LabView VIs** is released under the MIT License. See the **[LICENSE](LICENSE)** file for details.

## **Authors and Acknowledgment**

The author of this project (**[Matas Petreikis](https://github.com/mpetreikis)**) would like to acknowledge these contributions:
- User _Chris_G._ for their example VI, on which both of my VIs were based **heavily** ([link](https://forums.ni.com/t5/Example-Code/Synchronizing-Analog-Output-and-Digital-Output-Signals-Using/ta-p/3536335))
- _Jim Hokanson_ for their _TDMS Reader_ library, which were crucial for my own Matlab functions and which saved me loads of time when dealing with .tdms files


