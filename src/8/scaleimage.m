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

% 行列演算によるピクセルのマッピングと値の割り当て
% 1. 出力画像の座標グリッドを作成
[C, R] = meshgrid(1:new_cols, 1:new_rows);  % C: 列, R: 行

% 2. 元画像上の対応座標を計算
orig_R = round(R / scale);
orig_C = round(C / scale);

% 3. 元画像の範囲内にクリップ
orig_R = max(min(orig_R, rows), 1);
orig_C = max(min(orig_C, cols), 1);

% 4. 線形インデックスに変換
idx = sub2ind([rows, cols], orig_R(:), orig_C(:));

% 5. 各チャンネルをまとめてコピー
for d = 1:depth
    channel = orig_image(:,:,d);
    scaled_channel = channel(idx);
    scaled_image(:,:,d) = reshape(scaled_channel, new_rows, new_cols);
end

% 6. デバッグ用画像で対応する元画素を白でマーク
mask = false(rows, cols);
mask(idx) = true;
for d = 1:depth
    channel = debug_image(:,:,d);
    channel(mask) = 255;
    debug_image(:,:,d) = channel;
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
