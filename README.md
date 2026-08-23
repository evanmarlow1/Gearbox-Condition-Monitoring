# Gearbox Condition Monitoring

Code used to investigate the effectiveness of different **condition monitoring (CM) techniques** applied to gearbox vibration data.

The repository contains code for signal processing, manual vibration analysis, and machine learning/deep learning approaches for fault detection and classification.

## Repository Structure

```text
src/
├── DL/
│   └── Deep learning models and analysis
├── Functions/
│   └── Reusable MATLAB functions
├── ML/
│   └── Machine learning models and analysis
├── Manual Analysis/
│   └── Signal processing and manual fault analysis
└── README.md
```

## Datasets

The datasets used in this project are publicly available and must be downloaded separately from their respective sources.

### CWRU Bearing Dataset

Case Western Reserve University bearing vibration dataset.

[Download / access the CWRU dataset](https://engineering.case.edu/bearingdatacenter)

### Paderborn Bearing Dataset

Paderborn University bearing vibration dataset.

[Download / access the Paderborn dataset](https://mb.uni-paderborn.de/en/kat/research/bearing-datacenter/data-sets-and-download)

### OpenEI Dataset

OpenEI dataset used in the project.

[Download / access the OpenEI dataset](https://data.openei.org/submissions/738)

## Getting Started

1. Clone or download this repository.
2. Download the required datasets from the links above.
3. Place the datasets in the appropriate locations expected by the scripts.
4. Run the relevant MATLAB scripts from the `Manual Analysis`, `ML`, or `DL` directories.

> **Note:** Dataset files are not included in this repository due to their size and licensing/distribution restrictions.

## Methods

The repository contains implementations and analysis covering:

* Time-domain vibration analysis
* Frequency-domain analysis
* FFT and envelope analysis
* Kurtogram analysis
* Scalogram / wavelet analysis
* Machine learning
* Deep learning
* Fault classification
* Condition monitoring of gearbox and bearing vibration data

## Requirements

* MATLAB
* Required MATLAB toolboxes for the relevant analysis and machine learning scripts
* The datasets listed above

## Project Context

This code was developed as part of a project investigating **condition monitoring techniques for motorsport gearbox vibration data**, including the use of publicly available bearing datasets for comparison and validation.
