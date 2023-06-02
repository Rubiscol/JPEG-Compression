I = imread('peppers.png');
size(I)
I= rgb2ycbcr(I);
% Measure the image size
ImageSize = 8*numel(I);
% downsample (4:2:0)
[y,cb,cr]=downsampling(I);
Q = [120 120 103 109 81 87  68 64;
     112 49  40  28  26 24  22 78;
     95  35  10  12  14 12  22 92;
     103 37  14  10  11 14  24 61;
     95  29  13  16  12 14  24 60;
     112 49  14  16  18 16  19 57;
     112 28  51  72  64 55  56 51;
     95  112 95  112 95 112 95 112];

% FFT and quantinization Encoder
Y_fft=FFT(Q,y);
Cb_fft=FFT(Q,cb);
Cr_fft=FFT(Q,cr);

% % 
tic
[Y_width,Y_height,Y1,Y2,Y3,Y4]=Huffman_encode((Y_fft));
[Cb_width,Cb_height,Cb1,Cb2,Cb3,Cb4]=Huffman_encode(Cb_fft);
[Cr_width,Cr_height,Cr1,Cr2,Cr3,Cr4]=Huffman_encode(Cr_fft);

compression_rate=(numel(Y3)+numel(Cb3)+numel(Cr3))/(ImageSize)

Y=Huffman_decode(Y_width,Y_height,Y1,Y2,Y3,Y4);
Cb=Huffman_decode(Cb_width,Cb_height,Cb1,Cb2,Cb3,Cb4);
Cr=Huffman_decode(Cr_width,Cr_height,Cr1,Cr2,Cr3,Cr4);
elapsedTime = toc;

% display the elapsed time
disp(['Huffman time: ' num2str(elapsedTime) ' seconds']);

Y_fft=Y(1:Y_width,1:Y_height);
Cb_fft=Cb(1:Cb_width,1:Cb_height);
Cr_fft=Cr(1:Cr_width,1:Cr_height);

%% 

% IFFT and quantinization Decoder
Y=IFFT(Q,Y_fft);
Cb=IFFT(Q,Cb_fft);
Cr=IFFT(Q,Cr_fft);
%% 
% upsample (4:2:0)
Y=upsampling(Y,Cb,Cr);
dispalyDownsampling(I,real(Y))
displayCompression(I,Y)





