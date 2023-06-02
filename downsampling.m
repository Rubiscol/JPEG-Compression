function [y,cb,cr]=downsampling(I)
y=I(:,:,1);
cb=uint8(zeros(size(I,1)/2,size(I,2)/2));
cr=uint8(zeros(size(I,1)/2,size(I,2)/2));
for i=1:2:(size(I,1)-1)
   for j=1:2:(size(I,2)-1)
    cb((i+1)/2,(j+1)/2)= I(i,j,2);
    cr((i+1)/2,(j+1)/2)= I(i,j,3);
   end
end
end
