% 72443542 齋藤淳平
% 縮小・拡大どちらもでできる必要がある
% 宛先側のサイズでループを回した方が良い

clc;clear;close all;

% 任意の画像ファイルを選択
I = uigetfile('*.jpg;*.jpeg;*.png','File Selector');
orig_image = imread(I);

% 元画像のサイズを取得
[rows, cols, depth] = size(orig_image);

% 縮小・拡大率を指定
scale = input('Enter scale factor (e.g., 0.5 for reduction, 2 for enlargement): ');
new_rows = round(rows * scale);
new_cols = round(cols * scale);

% 新しい画像の初期化
scaled_image = zeros(new_rows, new_cols, depth, 'uint8');
debug_image = orig_image;
% ピクセルのマッピングと値の割り当て
for r = 1:new_rows
    for c = 1:new_cols                                
        orig_r = round(r / scale);
        orig_c = round(c / scale);
        % 元画像の範囲内に収める
        orig_r = min(orig_r, rows);
        orig_c = min(orig_c, cols);
        scaled_image(r, c, :) = orig_image(orig_r, orig_c, :);
        debug_image(orig_r, orig_c, :) = 255; % Mark the mapped pixel in the debug image
    end
end

% 結果の表示
figure;
subplot(3,2,1);
imshow(orig_image);
title('Original Image');

subplot(3,2,2);
imshow(scaled_image);
title('Scaled Image');

%画像の左上部分を切り出して表示
subplot(3,2,3);
imshow(orig_image(1:min(100,rows), 1:min(100,cols), :));
title('Top-Left of Original Image');

subplot(3,2,4);
imshow(scaled_image(1:min(100,new_rows), 1:min(100,new_cols), :));
title('Top-Left of Scaled Image');

subplot(3,2,5);
imshow(debug_image);
title('Debug Image (Mapped Pixels Marked)');