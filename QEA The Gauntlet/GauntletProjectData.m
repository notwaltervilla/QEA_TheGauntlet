%create the mesh, less points so vectors visible
[x,y]=meshgrid(-2:0.05:3,-3.5:0.05:0.9);
%[x,y]=meshgrid(-2:0.15:3,-3.5:0.15:0.9);

%define the components of the gradient
hold off
v = (-(sqrt((x+.25).^2+(y+1).^2)) - (sqrt((x-1).^2+(y+.7).^2)) - (sqrt((x-1.41).^2+(y+2).^2))) + 3*(sqrt((x-.75).^2+(y+2.5).^2));

% plots the potential field for the neato's path
quiver(x,v,y,v)

% adds the walls as borders for the neato, so it doesn't escape, and avoids
% them alltogether
for a = -1.5:.1:2.5
    v = v - 0.1*log(sqrt((x-a).^2 + (y-1).^2));
end
for a = -1.5:.1:2.5
    v = v - 0.1*log(sqrt((x-a).^2 + (y+3.37).^2));
end
for b = -3.37:.1:1
    v = v - 0.1*log(sqrt((x+1.5).^2 + (y-b).^2));
end
for b = -3.37:.1:1
    v = v - 0.1*log(sqrt((x-2.5).^2 + (y-b).^2));
end

% creates a 3D surface plot to visually represent the gradient descent
surf(x,y,v)

% creates a 3d contour plot (also to visually represent gradient descent)
%contour(x,y,v,50)


% the following is to calculate the path of gradient descent (outputs a 2D
% curve)
%{
syms x y;
f = (-(sqrt((x+.25).^2+(y+1).^2)) - (sqrt((x-1).^2+(y+.7).^2)) - (sqrt((x-1.41).^2+(y+2).^2))) + 3*(sqrt((x-.75).^2+(y+2.5).^2));
grad = [diff(f,x); diff(f,y)];
step_size = .1;
r = [1; -1];

while true
    grad_num = double(subs(grad,[x y], [r(1,end) r(2,end)]));
    r(:,end+1) = r(:,end) + grad_num*step_size;
    if norm(grad_num) < 0.01
        break
    end
end

scatter(r(1,:),r(2,:),".")
%}