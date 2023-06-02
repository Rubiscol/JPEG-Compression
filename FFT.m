function A= FFT(Q,y)
    A=zeros(size(y));
    for j = 1:8:size(y,1)-7
        for k = 1:8:size(y,2)-7
            padding = y(j:j+7,k:k+7);
            freq = fft2(padding);
            freq=fftshift(freq);
            freq = round(freq./Q);
            A(j:j+7,k:k+7) = freq;
        end
    end
%     padding if possible
    A(j+8:j+7+mod(size(A,1),8),:)=repmat(A(j+7,:),mod(size(A,1),8),1);
    A(:,k+8:k+7+mod(size(A,2),8))=repmat(A(:,k+7),1,mod(size(A,2),8));
end