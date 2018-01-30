# flexecg-ios
iOS application to receive, filter, and graph ECG data from the flexecg-nrf51 project

Our BSEE capstone team project was an ECG system. The sensor module was made with ultra-thin FR4 material so it would be flexible and appropriate for a wearable device. It detects the electrical activity of the heart using capacitive coupling, so it can be used through clothing. After some signal processing, the sensor module sends the analog cardiac signal to an NRF51422 SoC, which converts the analog signal to digital, and sends the signal data via Bluetooth LE to an iPad where it is stored. Then some digital filtering is applied before the result is displayed graphically.

A link to a demonstration video:
https://www.youtube.com/watch?v=bgO3KgLusN4
