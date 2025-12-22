%% morphology
%
clc;clear;close all;

% 任意の画像ファイルを選択
I = uigetfile('*.jpg;*.jpeg;*.png','File Selector');
Is = imread(I);


% Ig = rgb2gray(Is);

subplot(1,2,1);
imshow(Is);
% The second argument is 'erode' for eroding.
P = morph(Is, 'dilate');
% We can repeat the morphological transformation.
P = morph(P, 'dilate');
P = morph(P, 'dilate');
P = morph(P, 'dilate');
subplot(1,2,2);
imshow(P);


%% morphology transformation
%
function R = morph(Ig, op)
  [r, c, d] = size(Ig);
  isErode = strcmp(op, 'erode');
  isDilate = strcmp(op, 'dilate');
  if ~isErode && ~isDilate
      error('Unknown op: %s', op);
  end
  R = uint8(zeros(r, c, d));
  for i = 1:r
    for j = 1:c
      mc = reshape(Ig(i, j, :), 1, []);
      for k = -1:1
        for s = -1:1
          cr = i + k;
          cc = j + s;
          if i + k < 1 % 左端の1列の画素の場合
            cr = abs(i + k) + 1; % 折り返し ex(-1 -> 2)
          elseif i + k > r % 右端の1列の画素の場合
            cr = 2 * r - i - k; % 折り返し ex(r+1 -> r-1)
          end

          if j + s < 1 % 上端の1行の画素の場合
            cc = abs(j + s) + 1; % 折り返し ex(-1 -> 2)
          elseif j + s > c % 下端の1行の画素の場合
            cc = 2 * c - j - s; % 折り返し ex(c+1 -> c-1)
          end

          for md = 1:d
            val = Ig(cr, cc, md);
            if isErode
              if val < mc(md)
                mc(md) = val; % 最小値を選択
              end
            else
              if val > mc(md)
                mc(md) = val; % 最大値を選択
              end
            end
          end
        end
      end
      R(i, j, :) = reshape(mc, 1, 1, []);
    end
  end
end
