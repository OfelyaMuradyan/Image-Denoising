# Image Denoising in R

This project demonstrates various image denoising techniques applied to an image in R. The techniques include adding different types of noise (Gaussian, Salt and Pepper, and Poisson) and then denoising the image using Gaussian, Mean, and Median filters. The performance of each denoising method is evaluated using Mean Squared Error (MSE), Peak Signal-to-Noise Ratio (PSNR), and Signal-to-Noise Ratio (SNR).

## Table of Contents

- [Introduction](#introduction)
- [Requirements](#requirements)
- [Usage](#usage)
- [Denoising Techniques](#denoising-techniques)
- [Evaluation Metrics](#evaluation-metrics)
- [Results](#results)

## Introduction

Image denoising is a fundamental problem in image processing, where the goal is to remove noise from an image. This project applies and evaluates several denoising techniques on a grayscale image.

## Requirements

- R
- `jpeg` library

You can install the required library using the following command in R:
```r
install.packages("jpeg")
```

## Usage

1. Clone the repository or download the script.
2. Place your image in the specified directory.
3. Load and run the script in R.

Example of running the script:

```r
library(jpeg)

# Load the image
img <- readJPEG("~/Desktop/Image Denoising/msg1861748956-131791.jpg")

# Follow the steps as defined in the script to add noise and apply denoising filters
```

## Denoising Techniques

### Adding Noise

1. **Gaussian Noise**: Random noise with a Gaussian distribution is added to the image.
2. **Salt and Pepper Noise**: Random pixels are set to black or white.
3. **Poisson Noise**: Noise generated using a Poisson distribution based on the image pixel values.

### Denoising Filters

1. **Gaussian Filter**: Uses a Gaussian kernel to smooth the image, reducing noise.
2. **Mean Filter**: Replaces each pixel value with the mean of the neighboring pixels.
3. **Median Filter**: Replaces each pixel value with the median of the neighboring pixels.

## Evaluation Metrics

1. **Mean Squared Error (MSE)**: Measures the average squared difference between the original and denoised images.
2. **Peak Signal-to-Noise Ratio (PSNR)**: Measures the peak error between the original and denoised images.
3. **Signal-to-Noise Ratio (SNR)**: Measures the ratio of the signal power to the noise power.

## Results

The script prints the MSE, PSNR, and SNR values for each denoising technique, providing an objective measure of their performance.

## Contributors

Thanks to the following people who have contributed to this project:

- **Melkonyan Simon** 
- **Mkrtchyan Narek** 
- **Aghayan Zhenya** 
