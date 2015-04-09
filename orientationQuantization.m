function [ quan_data ] = orientationQuantization( gradient_data )
%orientationQuantization
%   use this to quantization the gradient to 20d

threshold=1.29107;

gr=(1+sqrt(5))/2;

P=[1,1,1;
    -1,-1,1;
    -1,1,1;
    1,-1,1;
    0,1/gr,gr;
    0,-1/gr,gr;
    1/gr,gr,0;
    1/gr,-gr,0;
    gr,0,1/gr;
    -gr,0,1/gr];

width=size(gradient_data,1);
height=size(gradient_data,2);
length=size(gradient_data,3);
quan_data=zeros(width,height,length,20);
for x=1:width
    for y=1:height
        for l=1:length
            gb=[gradient_data(x,y,l,1);gradient_data(x,y,l,2);gradient_data(x,y,l,3)];
            norm_gb=normest(gb);
            if norm_gb==0
                continue;
            end
            qb=P*gb/norm_gb;
            hist=zeros(1,size(qb,1)*2);
            count=1;
            for i=qb'
                if i>threshold
                    hist(count)=i-threshold;
                else
                    if i<-threshold
                        hist(count+10)=-i-threshold;
                    end
                end
                count=count+1;
            end
            norm_hist=normest(hist);
            hist=norm_gb*hist/norm_hist;
            quan_data(x,y,l,:)=hist;
        end
    end
end

end