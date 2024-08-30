% Read the image containing the oil spill
image = imread('oilspill.jpg');

% Display the original image
subplot(3, 3, 1);
imshow(image);
title('Original Image');

% Convert the image to grayscale
gray_image = rgb2gray(image);

% Display the grayscale image
subplot(3, 3, 2);
imshow(gray_image);
title('Grayscale Image');

% Calculate and display the histogram of the grayscale image
subplot(3, 3, 3);
imhist(gray_image);
title('Grayscale Image Histogram');

% Apply median filtering to reduce noise
filtered_image = medfilt2(gray_image, [5, 5]);

% Display the filtered image
subplot(3, 3, 4);
imshow(filtered_image);
title('Filtered Image');

% Enhance the contrast using histogram equalization
enhanced_image = histeq(filtered_image);

% Display the enhanced image
subplot(3, 3, 5);
imshow(enhanced_image);
title('Enhanced Image');

% Calculate and display the histogram of the enhanced image
subplot(3, 3, 6);
imhist(enhanced_image);
title('Enhanced Image Histogram');

% Perform edge detection using the Canny edge detector
edge_image = edge(enhanced_image, 'Canny');

% Display the edge-detected image
subplot(3, 3, 7);
imshow(edge_image);
title('Edge-Detected Image');

% Apply morphological operations to clean up the edges
se = strel('disk', 5);
cleaned_edge_image = imdilate(edge_image, se);

% Display the cleaned edge image
subplot(3, 3, 8);
imshow(cleaned_edge_image);
title('Cleaned Edge Image');

% Fill holes in the cleaned edge image
filled_image = imfill(cleaned_edge_image, 'holes');

% Display the filled image
subplot(3, 3, 9);
imshow(filled_image);
title('Filled Image');

% You can now proceed with further oil spill detection methods using 'filled_image'.

% Example: Set a threshold for the minimum oil spill area
min_oil_spill_area = 1000;

% Perform connected component analysis
cc = bwconncomp(filled_image);
stats = regionprops(cc, 'Area', 'PixelList');

% Create a binary mask for detected oil spills
oil_spill_mask = false(size(filled_image));
for i = 1:cc.NumObjects
    if stats(i).Area > min_oil_spill_area
        oil_spill_mask(sub2ind(size(filled_image), stats(i).PixelList(:,2), stats(i).PixelList(:,1))) = true;
    end
end

% Display the original image with detected oil spills outlined
figure;
imshow(image);
hold on;

% Outline detected spills on the original image
boundaries = bwboundaries(oil_spill_mask);
for k = 1:length(boundaries)
    boundary = boundaries{k};
    plot(boundary(:, 2), boundary(:, 1), 'r', 'LineWidth', 2);
end
hold off;
