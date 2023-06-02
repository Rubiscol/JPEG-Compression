function B=IFFT(Q,A)
    B=zeros(size(A));
    for j = 1:8:size(A,1)-7
        for k = 1:8:size(A,2)-7
            freq=A(j:j+7,k:k+7);
            freq=Q.*freq;
            freq=fftshift(freq);
            padding=ifft2(freq);
            B(j:j+7,k:k+7)=padding;
        end
    end
%     padding if possible
    B(j+8:j+7+mod(size(A,1),8),:)=repmat(B(j+7,:),mod(size(A,1),8),1);
    B(:,k+8:k+7+mod(size(A,2),8))=repmat(B(:,k+7),1,mod(size(A,2),8));
end
