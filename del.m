function[x,y] = del(x,y,xcord,ycord)
x = x(x~=xcord); % replace "x" and "y" with actual influxdb arrays when
y = y(y~=ycord); % aws server is functional again
promptx = ["the x-value of the deleted datapoint is ",num2str(xcord)];
prompty = ["the y-value of the deleted datapoint is ";num2str(ycord)];
disp(promptx); 
disp(prompty);
plot(x,y,"-o");
xlabel('X-axis');
ylabel('Y-axis');
title('Interactive Plot');
grid on;
drawnow;
end







