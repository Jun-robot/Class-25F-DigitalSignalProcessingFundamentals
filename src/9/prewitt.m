%% sigledifffilter
%
I = uigetfile('*.jpg;*.jpeg;*.png','File Selector');
b = imread(I);
colormap
bw = double(rgb2gray(b));
[r,c,~] = size(bw);
dv = double(zeros(r,c));
dh = double(zeros(r,c));

for i=2:r-1
    for j=2:c-1
        dv(i,j) = 0.5*abs(bw(i+1,j) - bw(i-1,j));
        dh(i,j) = 0.5*abs(bw(i,j+1) - bw(i,j-1));
    end
end

d = (dv+dh)/2.0;
subplot(2,2,1), image(b);
subplot(2,2,2), image(d);
subplot(2,2,3), imshow(dv);
subplot(2,2,4), imshow(dh);
% im.CDataMapping = 'scaled';
% image(d);


% for i=1:r
% for j=1:c
% if (i == 1)
% imnus1 = i+1;
% else
% imnus1 = i-1;
% end
% if (j == 1)
% jmnus1 = j+1;
% else
% jmnus1 = j-1;
% end
% dv(i,j) = ceil(9-abs(bw(i,j) - bw(imnus1,j)));
% dh(i,j) = ceil(9-abs(bw(i,j) - bw(i,jmnus1)));
% end
% end
% d = (dv+dh)/2.0;
% subplot(1,2,1), image(d);
% subplot(1,2,2), image(b);