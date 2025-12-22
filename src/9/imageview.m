 
% Select and display an image with a scale slider.
[fileName, filePath] = uigetfile( ...
    {'*.png;*.jpg;*.jpeg;*.bmp;*.tif;*.tiff;*.gif', 'Image Files'; '*.*', 'All Files'}, ...
    'Select an image');

if isequal(fileName, 0)
    return;
end

img = imread(fullfile(filePath, fileName));

scaleMin = 10;
scaleMax = 300;
scaleDefault = 100;

fig = figure('Name', fileName, 'NumberTitle', 'off');
ax = axes('Parent', fig, 'Units', 'normalized', 'Position', [0.05 0.12 0.9 0.83]);
imshow(scaleImage(img, scaleDefault / 100), 'Parent', ax, 'InitialMagnification', 100);
axis(ax, 'image');

scaleText = uicontrol(fig, 'Style', 'text', 'Units', 'normalized', ...
    'Position', [0.02 0.02 0.25 0.05], 'String', 'Scale: 100%');
slider = uicontrol(fig, 'Style', 'slider', 'Min', scaleMin, 'Max', scaleMax, ...
    'Value', scaleDefault, 'Units', 'normalized', 'Position', [0.28 0.02 0.7 0.05], ...
    'Callback', @updateScale);
set(slider, 'SliderStep', [1 / (scaleMax - scaleMin), 10 / (scaleMax - scaleMin)]);

setappdata(fig, 'img', img);
setappdata(fig, 'ax', ax);
setappdata(fig, 'scaleText', scaleText);

function updateScale(src, ~)
    figHandle = ancestor(src, 'figure');
    imgData = getappdata(figHandle, 'img');
    axHandle = getappdata(figHandle, 'ax');
    textHandle = getappdata(figHandle, 'scaleText');
    scalePercent = round(get(src, 'Value'));
    set(textHandle, 'String', sprintf('Scale: %d%%', scalePercent));
    scaledImage = scaleImage(imgData, scalePercent / 100);
    imshow(scaledImage, 'Parent', axHandle, 'InitialMagnification', 100);
    axis(axHandle, 'image');
end

function scaled_image = scaleImage(orig_image, scale)
    [rows, cols, depth] = size(orig_image);
    new_rows = round(rows * scale);
    new_cols = round(cols * scale);

    new_rows = max(new_rows, 1);
    new_cols = max(new_cols, 1);

    scaled_image = zeros(new_rows, new_cols, depth, 'uint8');
    debug_image = orig_image;

    src_image = orig_image;
    if scale < 1
        src_image = gaussianLowpass(src_image, 0.5 / scale);
    end

    % 1. Output image coordinate grid.
    [C, R] = meshgrid(1:new_cols, 1:new_rows);  % C: col, R: row

    % 2. Map to original image coordinates.
    orig_R = round(R / scale);
    orig_C = round(C / scale);

    % 3. Clip to original bounds.
    orig_R = max(min(orig_R, rows), 1);
    orig_C = max(min(orig_C, cols), 1);

    % 4. Convert to linear indices.
    idx = sub2ind([rows, cols], orig_R(:), orig_C(:));

    % 5. Copy each channel.
    for d = 1:depth
        channel = src_image(:, :, d);
        scaled_channel = channel(idx);
        scaled_image(:, :, d) = reshape(scaled_channel, new_rows, new_cols);
    end

    if depth == 1
        scaled_image = scaled_image(:, :, 1);
    end
end

function filtered_image = gaussianLowpass(orig_image, sigma)
    kernel = gaussianKernel1D(sigma);
    [rows, cols, depth] = size(orig_image);
    filtered_image = zeros(rows, cols, depth);

    for d = 1:depth
        channel = double(orig_image(:, :, d));
        channel = conv2(channel, kernel, 'same');
        channel = conv2(channel, kernel', 'same');
        filtered_image(:, :, d) = channel;
    end

    filtered_image = uint8(min(max(filtered_image, 0), 255));
end

function kernel = gaussianKernel1D(sigma)
    radius = max(1, ceil(3 * sigma));
    x = -radius:radius;
    kernel = exp(-(x .^ 2) / (2 * sigma ^ 2));
    kernel = kernel / sum(kernel);
end
