function dispalyDownsampling(I,Y)
figure
subplot(2,3,1)
imshow(ycbcr2rgb(I))
title('Original picture')
subplot(2,3,2)
imshow(ycbcr2rgb(Y))
title('Downsampling picture')
lb = {'Y', 'Cb', 'Cr'};
for channel = 1:3
    C = Y;
    C(:,:,setdiff(1:3,channel)) = 128;
    subplot(2,3,channel+2)
    imshow(ycbcr2rgb(C))
    title([lb{channel} ' component'])
end
end