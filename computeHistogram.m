function [hist_data] = computeHistogram( data, xGrid,yGrid,tGrid, S ,normalize)
%computeHistogram
%   compute histgram of the block

if nargin<6
    normalize=true;
end

if nargin<5
    S=3;
end

gradient_data=computeMeanGradient(data,xGrid*S,yGrid*S,tGrid*S);
quan_data=orientationQuantization(gradient_data);


width=size(quan_data,1);
height=size(quan_data,2);
length=size(quan_data,3);

hist_data=zeros(xGrid,yGrid,tGrid,20);

for x=1:width
    hx=floor((x-1)/S)+1;
    for y=1:height
        hy=floor((y-1)/S)+1;
        for l=1:length
            hl=floor((l-1)/S)+1;
            hist_data(hx,hy,hl,:)=hist_data(hx,hy,hl,:)+quan_data(x,y,l,:);
        end
    end
end

if normalize==true
    for x=1:xGrid
        for y=1:yGrid
            for l=1:tGrid
                h_norm=normest(reshape(hist_data(x,y,l,:),1,20));
                if h_norm~=0
                    hist_data(x,y,l,:)=hist_data(x,y,l,:)/h_norm;
                end
            end
        end
    end
end

end

