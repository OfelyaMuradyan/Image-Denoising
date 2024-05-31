library(jpeg)

# Load the image
img <- readJPEG("~/Desktop/Image Denoising/msg1861748956-131791.jpg")

# Image dimensions
width <- ncol(img)
height <- nrow(img)

# The original image
plot(0:1, 0:1, type = "n", xlab = "", ylab = "", xlim = c(0, 1), ylim = c(0, 1), asp = height / width)
rasterImage(img, 0, 0, 1, 1)

# The pixel matrix of image
img_matrix <- matrix(img, nrow = height, ncol = width)
#print(img_matrix[19])

### Adding Gaussian noise ###
sigma <- 0.5
noise <- matrix(rnorm(width * height, mean = 0, sd = sigma), nrow = height, ncol = width)
noisy_img <- img_matrix + noise

# Keeping pixel values to range [0, 1]
noisy_img <- pmax(pmin(noisy_img, 1), 0)

# The noisy image
plot(0:1, 0:1, type = "n", xlab = "", ylab = "", xlim = c(0, 1), ylim = c(0, 1), asp = nrow(img) / ncol(img))
rasterImage(noisy_img, 0, 0, 1, 1)

### Adding Salt and Pepper noise ###
add_salt_and_pepper <- function(image, noise_level) {
  total_pixels <- length(image)
  num_salt <- floor(total_pixels * noise_level / 2)
  num_pepper <- num_salt
  salt <- sample(total_pixels, num_salt)
  pepper <- sample(total_pixels, num_pepper)
  image[salt] <- 1
  image[pepper] <- 0
  return(image)
}

# Applying salt-and-pepper noise
noisy_img_sp <- add_salt_and_pepper(as.vector(img), noise_level = 0.1)

# Converting vector to matrix
noisy_img_sp_matrix <- matrix(noisy_img_sp, nrow = height, ncol = width)

# The noisy image
plot(0:1, 0:1, type = "n", xlab = "", ylab = "", xlim = c(0, 1), ylim = c(0, 1), asp = nrow(img) / ncol(img))
rasterImage(noisy_img_sp_matrix, 0, 0, 1, 1)

### Adding Poisson noise ###
add_poisson_noise <- function(image) {
  noisy_image <- rpois(length(image), lambda = image * 255) / 255
  return(noisy_image)
}

# Applying Poisson noise
noisy_img_poisson <- add_poisson_noise(as.vector(img))

# Clipping pixel values to range [0, 1]
noisy_img_poisson <- pmin(pmax(noisy_img_poisson, 0), 1)

# Converting vector to matrix
noisy_img_poisson_matrix <- matrix(noisy_img_poisson, nrow = height, ncol = width)

# The noisy image with Poisson noise
plot(0:1, 0:1, type = "n", xlab = "", ylab = "", xlim = c(0, 1), ylim = c(0, 1), asp = nrow(img) / ncol(img))
rasterImage(noisy_img_poisson_matrix, 0, 0, 1, 1)

### Gaussian filter ###
gaussian_filter <- function(matrixx, sigma) {
  size <- ceiling(1.7 * sigma)
  x <- seq(-size, size, by = 1)
  kernel <- exp(-(x^2) / (2 * sigma^2))
  kernel <- kernel / sum(kernel)
  
  filtered_img <- t(apply(matrixx, 1, function(x) filter(x, kernel, sides = 2)))
  filtered_img <- t(apply(filtered_img, 1, function(x) filter(x, kernel, sides = 2)))
  
  return(filtered_img)
}

# Applying Gaussian filter
sigma <- 2.5
denoised_img_gaussian <- gaussian_filter(noisy_img, sigma)

# The denoised image
plot(0:1, 0:1, type = "n", xlab = "", ylab = "", xlim = c(0, 1), ylim = c(0, 1), asp = nrow(img) / ncol(img))
rasterImage(denoised_img_gaussian, 0, 0, 1, 1)

### Mean filter ###
mean_filter <- function(image_matrix, filter_size) {
  kernel <- matrix(1, nrow = filter_size, ncol = filter_size) / (filter_size^2)
  
  # Padding of the image
  pad_size <- floor(filter_size / 2)
  padded_img <- matrix(0, nrow = nrow(image_matrix) + 2 * pad_size, ncol = ncol(image_matrix) + 2 * pad_size)
  padded_img[(pad_size + 1):(nrow(image_matrix) + pad_size), (pad_size + 1):(ncol(image_matrix) + pad_size)] <- image_matrix
  
  filtered_img <- matrix(0, nrow = nrow(image_matrix), ncol = ncol(image_matrix))
  
  for (i in 1:nrow(image_matrix)) {
    for (j in 1:ncol(image_matrix)) {
      region <- padded_img[i:(i + filter_size - 1), j:(j + filter_size - 1)]
      filtered_img[i, j] <- mean(region)
    }
  }
  
  return(filtered_img)
}

# Applying mean filter
filter_size <- 3
denoised_img_mean <- mean_filter(noisy_img_poisson_matrix, filter_size)

# The denoised image
plot(0:1, 0:1, type = "n", xlab = "", ylab = "", xlim = c(0, 1), ylim = c(0, 1), asp = nrow(img) / ncol(img))
rasterImage(denoised_img_mean, 0, 0, 1, 1)

### Median filter ###
median_filter <- function(image_matrix, filter_size) {
  if (filter_size %% 2 == 0) {
    stop("Filter size must be an odd number.")
  }
  pad_size <- floor(filter_size / 2)
  padded_img <- matrix(0, nrow = nrow(image_matrix) + 2 * pad_size, ncol = ncol(image_matrix) + 2 * pad_size)
  padded_img[(pad_size + 1):(nrow(image_matrix) + pad_size), (pad_size + 1):(ncol(image_matrix) + pad_size)] <- image_matrix
  
  filtered_img <- matrix(0, nrow = nrow(image_matrix), ncol = ncol(image_matrix))
  
  for (i in 1:nrow(image_matrix)) {
    for (j in 1:ncol(image_matrix)) {
      region <- padded_img[i:(i + filter_size - 1), j:(j + filter_size - 1)]
      filtered_img[i, j] <- median(region)
    }
  }
  
  return(filtered_img)
}

# Applying the median filter
filter_size <- 3
denoised_img_median <- median_filter(noisy_img_sp_matrix, filter_size)

plot(0:1, 0:1, type = "n", xlab = "", ylab = "", xlim = c(0, 1), ylim = c(0, 1), asp = nrow(img) / ncol(img))
rasterImage(denoised_img_median, 0, 0, 1, 1)


### Metrics ###
mse <- function(original, denoised) {
  mse <- mean((original - denoised) ^ 2, na.rm = TRUE)
  return(mse)
}

psnr <- function(original, denoised) {
  mse <- calculate_mse(original, denoised)
  max_pixel <- 1
  psnr <- 10 * log10(max_pixel^2 / mse)
  return(psnr)
}

snr <- function(original, denoised) {
  signal_power <- mean(original^2)
  noise_power <- calculate_mse(original, denoised)
  snr <- 10 * log10(signal_power / noise_power)
  return(snr)
}


## Calculate metrics
mse_gaussian <- mse(img_matrix, denoised_img_gaussian)
psnr_gaussian <- psnr(img_matrix, denoised_img_gaussian)
snr_gaussian <- snr(img_matrix, denoised_img_gaussian)

mse_mean <- mse(img_matrix, denoised_img_mean)
psnr_mean <- psnr(img_matrix, denoised_img_mean)
snr_mean <- snr(img_matrix, denoised_img_mean)

mse_median <- mse(img_matrix, denoised_img_median)
psnr_median <- psnr(img_matrix, denoised_img_median)
snr_median <- snr(img_matrix, denoised_img_median)

cat("Gaussian Filter:\n")
cat("MSE:", mse_gaussian, "\n")
cat("PSNR:", psnr_gaussian, "\n")
cat("SNR:", snr_gaussian, "\n")


cat("Mean Filter:\n")
cat("MSE:", mse_mean, "\n")
cat("PSNR:", psnr_mean, "\n")
cat("SNR:", snr_mean, "\n")

cat("Median Filter:\n")
cat("MSE:", mse_median, "\n")
cat("PSNR:", psnr_median, "\n")
cat("SNR:", snr_median, "\n")
