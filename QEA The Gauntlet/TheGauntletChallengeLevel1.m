% For simulated Neatos only:
% Place the Neato in the specified x, y position and specified heading vector.
function placeNeato(posX, posY, headingX, headingY)
    svc = rossvcclient('gazebo/set_model_state');
    msg = rosmessage(svc);
    
    msg.ModelState.ModelName = 'neato_standalone';
    startYaw = atan2(headingY, headingX);
    quat = eul2quat([startYaw 0 0]);

    msg.ModelState.Pose.Position.X = posX;
    msg.ModelState.Pose.Position.Y = posY;
    msg.ModelState.Pose.Position.Z = 1.0;
    msg.ModelState.Pose.Orientation.W = quat(1);
    msg.ModelState.Pose.Orientation.X = quat(2);
    msg.ModelState.Pose.Orientation.Y = quat(3);
    msg.ModelState.Pose.Orientation.Z = quat(4);

    % put the robot in the appropriate place
    ret = call(svc, msg);
    pub = rospublisher('raw_vel');
    message = rosmessage(pub);
    stopMsg = rosmessage(pub);
    stopMsg.Data = [0 0];
    send(pub, stopMsg);
    pause(1);
    
    % moves the neato for the first line segment of the gradient descent
    % path
    start = rostime('now');
    message.Data = [1 1];
    send(pub, message);
    for i = 1:500
        current = rostime('now') - start;
        current.seconds
        if current.seconds > 1.5
            message.Data = [0 0];
            send(pub, message);
        end
    end
    
    % the neato is rotated by the same amount as the gradient descent path
    pause(0.25);
    start = rostime('now');
    message.Data = [0.5 0];
    send(pub, message);
    for i = 1:150
        current = rostime('now') - start;
        current.seconds
        if current.seconds > 0.185
            message.Data = [0 0];
            send(pub, message);
        end
    end
    
    % the neato moves along the second line segment of the gradient descent
    % path
    pause(0.25);
    start = rostime('now');
    message.Data = [0.5 0.5];
    send(pub, message);
    for i = 1:500
        current = rostime('now') - start;
        current.seconds
        if current.seconds > 1.34
            message.Data = [0 0];
            send(pub, message);
        end
    end
end