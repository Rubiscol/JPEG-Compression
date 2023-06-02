function displayCompression(I,Y)
figure
subplot(1,2,1)
imshow(ycbcr2rgb(I))
title('Original')
subplot(1,2,2)
imshow(ycbcr2rgb(real(uint8(Y))));
title('Compressed')
end