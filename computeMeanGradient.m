function [ gradient_data ] = computeMeanGradient( data ,grad_width,grad_height,grad_length)
%compute gradient of the video data
% INPUT:  data: a three-dimensional matrix representing the input volume.
%               (:,:,f) gives grayscale pixel intensities at frame f
% OUTPUT: gradient_data: the mean of gradient in each block

%compute integrogram
[width,height,num_frame]=size(data);

block_width=ceil((width-2)/grad_width);
block_height=ceil((height-2)/grad_height);
block_length=ceil((num_frame-2)/grad_length);

inte_width=block_width*grad_width+1;
inte_height=block_height*grad_height+1;
inte_length=block_length*grad_length+1;

pading_x=floor((inte_width-width+2)/2);
pading_y=floor((inte_height-height+2)/2);
pading_t=floor((inte_length-num_frame+2)/2);

integrogram=zeros(inte_width,inte_height,inte_length,3);
data=double(data);

for t=2:(num_frame-1)
    for y=2:(height-1)
        for x=2:(width-1)
            gradient_x=data(x+1,y,t)-data(x-1,y,t);
            gradient_y=data(x,y+1,t)-data(x,y-1,t);
            gradient_t=data(x,y,t+1)-data(x,y,t-1);
            integrogram(x+pading_x-1,y+pading_y-1,t+pading_t-1,:)=double([gradient_x,gradient_y,gradient_t]);
        end
    end
end

for t=2:inte_length
    sum_of_plane=[0,0,0];
    for y=2:inte_height
        sum_of_line=[0,0,0];
        for x=2:inte_width
            sum_of_line=sum_of_line+[integrogram(x,y,t,1),integrogram(x,y,t,2),integrogram(x,y,t,3)];
            sum_of_box=[integrogram(x,y,t-1,1),integrogram(x,y,t-1,2),integrogram(x,y,t-1,3)];
            integrogram(x,y,t,:)=sum_of_line+sum_of_plane+sum_of_box;
        end
        sum_of_plane=sum_of_plane+sum_of_line;
    end
end

%compute mean gradient


gradient_data=zeros(grad_width,grad_height,grad_length,3);

for grad_t=1:grad_length
    t=(grad_t-1)*block_length+1;
        tl=t+block_length;
    for grad_y=1:grad_height
        y=(grad_y-1)*block_height+1;
            yh=y+block_height;
        for grad_x=1:grad_width
            x=(grad_x-1)*block_width+1;
                xw=x+block_width;
            
            gradient_data(grad_x,grad_y,grad_t,:) =(integrogram(xw,yh,tl,:)-integrogram(x,yh,tl,:)-integrogram(xw,y,tl,:)+integrogram(x,y,tl,:))-(integrogram(xw,yh,t,:)-integrogram(x,yh,t,:)-integrogram(xw,y,t,:)+integrogram(x,y,t,:));
        end
    end
end


end

