function fdata = readVideo(v)

readobj = VideoReader(v);
frameNumber = readobj.NumberOfFrames;
for f = 1:frameNumber
    Img = rgb2gray(read(readobj,f));
    fdata(:,:,f) = Img;
end