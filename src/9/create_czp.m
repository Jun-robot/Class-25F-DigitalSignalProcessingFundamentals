row = 300; 
col = 300; 
alpha = 1.0; 
czp = createczpfunc(row, alpha, 2); 
nmap = 256;
colormap(gray(nmap));
imshow(czp); 
imwrite(czp, 'czp.jpg'); 


% create cpz
%
function czp = createczpfunc(row, alpha, dim)
nmap = 256;
colormap(gray(nmap));
czp = uint8(zeros(row,row)); 
col = row; 
for i=1:row
  for j=1:row
      if (dim==2)
      dep = nmap/2*sin(pi()*(i-row/2)*(i-row/2)/alpha/row+pi()*(j-col/2)*(j-col/2)/alpha/col) + nmap/2;  
      else
          dep = nmap/2*sin(pi()*(j-row/2)*(j-row/2)/alpha/row) + nmap/2;  
      end
      czp(i,j) =uint8(dep); 
  end
end
%image(czp); 
%x = czp(1:row, col/2);
%xf = fft(x); 
%plot(x);
end