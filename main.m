function main(dataFile, outputFile, varargin)
% eg: main('test/output.mat', 'test/points.h5', 'test/test1.png', 'test/test2.png')
% when calling from deployed version this becomes:
% ./run_caltag.sh /path/to/MCR test/output.mat test/points.h5 test/*.png


nFiles = size( varargin, 2 );

if nFiles == 0
    error( 'No input files found' );
end
  
 
for i = 1:nFiles
    file = varargin{i};
    image = imread(file);
    image = rgb2gray(image);
    fprintf( '%s', file );
    [wPt,iPt] = caltag( image, dataFile, false );
    fprintf( ': %d\n', size(wPt,1) );
    imshow(file);
    hold on;
    plot(iPt(:,2),iPt(:,1),'bx','LineWidth',20)
    
    dset = ['/', file, '/world'];
    h5create( outputFile, dset, size(wPt), 'ChunkSize',[16,2], 'Deflate',9, 'Shuffle',true );
    h5write( outputFile, dset, wPt );
     
    dset = ['/', file, '/image'];
    h5create( outputFile, dset, size(iPt), 'ChunkSize',[16,2], 'Deflate',9, 'Shuffle',true );
    h5write( outputFile, dset, iPt );
end
