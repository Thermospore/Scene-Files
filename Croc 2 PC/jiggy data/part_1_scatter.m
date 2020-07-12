close all
clear all
%% results are stored in `part_1_results.mat`
% format:
%     x; z; angle; success
% success:
%    -1 = fail
%     0 = null
%     1 = succeed
%     2 = succeed, but not ideal
% data recording notes (FOR T1 ONLY):
%   face croc left then snap the camera
%   (such that the camera rotates around croc counter-clockwise)
%   so it is always in the same edge of the deadzone.
%
%   I believe the camera deadzone shrinks when camera snap is held.
%   Make sure to always use the camera snap to be consistent with this
%   data.
%
%   WAIT UNTIL YOU ARE SURE YOU'RE IN BEFORE LETTING GO OF FLIP!
%   sometimes (always?) if you get through the wall but let go of flip
%   too early, croc will just fall through to the ground, as opposed
%   to flipping and then staying inside   fc80
%
%   ALWAYS RUN BACK UP TO THE TOP BEFORE SETTING VALUES
%   directly setting them from post-attempt position
%   gave differing results. I guess it would be fine if you warped
%   to the top first, and then set the values from there.
%
%   when setting values, don't have croc turn more than 90 degrees
%   from his previous position, as this seems to change results?
%   probably wait standing back a tad looking into the corner
%   (45 deg) when you poke the memory values
%
%   DOUBLE CHECK the values didn't shift after you reset them

load part_1_results_t2.mat
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
xlabel('X (campfire here)');
ylabel('Z (pet door here)');
zlabel('<- pet door  [ Angle ]  jiggy door ->');
%flip X axis to match viewpoint when doing skip
set(gca,'Xdir','reverse')
%flip angle axis. My brain just likes it this way better
set(gca,'Zdir','reverse')

f = success == 2;
plot3(x(f),z(f),angle(f),'b.');

f = success == -1;
plot3(x(f),z(f),angle(f),'r.');