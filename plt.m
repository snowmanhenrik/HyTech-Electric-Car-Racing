% In main, use this function in the format 
% "[x,y] = plt(x,y,<new-x-cord>,<new-y-cord>)". For example,
% "[x,y] = plt(x,y,1,2)" will plot (1,2) on the plot.           
% You have to initialize the arrays "x" and "y".

function[x,y] = plt(x,y,xcord,ycord)
x(end+1) = xcord; % replace "x" and "y" with actual influxdb arrays when
y(end+1) = ycord; % aws server is functional again
promptx = "the x-value of your inputted datapoint is ";
prompty = "the y-value of your inputted datapoint is ";
strxcord = num2str(xcord);
strycord = num2str(ycord);
a = [promptx,strxcord];
b = [prompty,strycord];
disp(a);
disp(b);
plot(x, y, '-o');
xlabel('X-axis');
ylabel('Y-axis');
title('Interactive Plot');
grid on;
drawnow;
end





