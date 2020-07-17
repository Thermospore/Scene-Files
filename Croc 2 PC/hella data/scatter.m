close all
clear all
%% results are stored in `results.mat`
% format:
%     x; z; angle; success
% success:
%    -1 = fail
%     0 = null
%     1 = succeed
% data recording notes:
%   use Type 2
%   stomp jump
%   start holding KB left + front flip in the air before stomp
%   hold until skip complete

load results.mat
x = Results(:,1);
z = Results(:,2);
angle = Results(:,3);
success = Results(:,4);

%% plots
f = success == 1;
plot3(x(f),z(f),angle(f),'g.');
hold on
grid on
axis equal
xlabel('X (box would be here)');
ylabel('Z (cage this way)');
zlabel('<- cage  [ Angle ]  box ->');
%flip X axis to match viewpoint when doing skip
set(gca,'Xdir','reverse')
%flip angle axis. My brain just likes it this way better
set(gca,'Zdir','reverse')

f = success == -1;
plot3(x(f),z(f),angle(f),'r.');