function [ gradHist ] = hog3d( data,xGrid,yGrid,tGrid )
%compute hog3d feature
% INPUT:  data: a three-dimensional matrix representing the input volume.
%               (:,:,f) gives grayscale pixel intensities at frame f
%         xGrid: number of divisions in X domain
%         yGrid: number of divisions in Y domain
%         tGrid: number of divisions in T domain
% OUTPUT: gradHist: final feature of the volume as a 4-D matrix. (y,x,t,:)
%                   gives feature vector at cell (y,x,t)


gradHist=computeHistogram(data,xGrid,yGrid,tGrid);
end

