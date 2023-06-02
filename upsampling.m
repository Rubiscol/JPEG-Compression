function Y= upsampling(y,cb,cr)
Y=uint8(zeros(size(y,1),size(y,2),3));
Y(:,:,1)=y;
for i=1:2:(size(y,1)-1)
   for j=1:2:(size(y,2)-1)
    Y(i:i+1,j:j+1,2)=cb((i+1)/2,(j+1)/2);
    Y(i:i+1,j:j+1,3)=cr((i+1)/2,(j+1)/2);
   end
end
end