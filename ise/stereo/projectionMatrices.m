%% Example of projection matrices and images
%
%

%%

% Two points in 3space, but placed in homogeneous coordinates
X = [10,20,10, 1;
    30,20,15, 1]';

% Focal length of the camera
f = 3;

% This is the camera projection matrix
P = [1 0 0 0 ;
    0 1 0 0 ;
    0 0 1/f 0 ];

x = P*X;

%% Make the coordinates homogeneous
h = x(3,:);
x = bsxfun(@times,x,1./h);

vcNewGraphWin;
plot3(X(1,1:2),X(2,(1:2)),X(3,1:2),'o')
hold on
plot3(x(1,1:2),[f,f],x(2,(1:2)),'x')
line([X(1,1),x(1,1)],[X(2,1),f],[X(3,1),x(2,1)]);
line([X(1,2),x(1,2)],[X(2,2),f],[X(3,2),x(2,2)]);
grid on

%% Make a plane for the camera plane.

% I think the plane goes through Y = f
