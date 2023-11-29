function [] = getdata()

bucketquery()
prompt1 = "Please input the *name* of the bucket you want to query: ";
bucketname = input(prompt1,'s');

dataf = 'from(bucket: "';
dataf2 = '") |> range(start: -';
prompt2 = "Please input the time range of data you want to query, for example, 7d: ";
timerange = input(prompt2,'s');
datab = ')';
data = [dataf bucketname dataf2 timerange datab];

body = matlab.net.http.MessageBody(data);
contentTypeField = matlab.net.http.field.ContentTypeField('application/vnd.flux'); 
acceptField = matlab.net.http.field.AcceptField('application/csv');
method = matlab.net.http.RequestMethod.POST;
auth = matlab.net.http.field.GenericField('Authorization','Token <TOKEN>'); %% replace <TOKEN> with actual token
header = [auth acceptField contentTypeField]; 
request = matlab.net.http.RequestMessage(method,header,body);

uri = matlab.net.URI('http://<IP>:8086/api/v2/query?org=<ORG>'); 
%% replace <IP> with ip address of influxDB database
%% replace <ORG> with your organization ID
response = send(request,uri);
structuredata = response.Body.Data;

for i = 1:width(structuredata)
    % List of unique values re-initialized per looped index
    columnName = structuredata.Properties.VariableNames{i};
    columnData = structuredata.(columnName);
        
    if iscell(columnData) && iscell(columnData{1})
        columnData = cellfun(@(c) c{1}, columnData, 'UniformOutput', false);
    end
    
    uniqueColumnValues = unique(columnData);
    disp(['Unique values for column "', columnName, '":']);
    disp(uniqueColumnValues);
    
    % Ask the user to select a value to filter by, or skip by pressing enter.
    prompt = sprintf("Please enter a value to filter the '%s' column, or press enter to skip: ", columnName);
    userCondition = input(prompt,'s');
    
    % Apply the filter if the user entered a condition.
    if ~isempty(userCondition)
        if iscell(structuredata.(columnName)) 
            %filter by string match
            structuredata1 = structuredata(strcmp(structuredata.(columnName), userCondition), :);

        else %filter by logic match
            structuredata1 = structuredata(structuredata.(columnName) == str2double(userCondition), :);
        end

        % If no rows remain after filtering
        while isempty(structuredata1)
            disp(['No matching data found for the filter: ', columnName, ' = ', userCondition]);
            promptempty = "Please enter a different value to filter by: ";
            userCondition = input(promptempty,"s");            
            if iscell(structuredata.(columnName)) 
                structuredata1 = structuredata(strcmp(structuredata.(columnName), userCondition), :);
            else 
                structuredata1 = structuredata(structuredata.(columnName) == str2double(userCondition), :);
            end
        end

        if ~isempty(structuredata1)
            structuredata = structuredata1;
        end
    end



structuredata.x_time = datetime(structuredata.x_time, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSSSSSSSS''Z''', 'TimeZone', 'UTC');

timeDifferences = structuredata.x_time - min(structuredata.x_time);

relativeSeconds = seconds(timeDifferences);

structuredata.relative_time_seconds = relativeSeconds;

timestamps = structuredata.relative_time_seconds;
sensorvalues = structuredata.x_value;


saveddata = structuredata(:,["relative_time_seconds","x_value"]);

save('savefile.mat', 'saveddata');

plot(timestamps, sensorvalues, '-s', 'MarkerSize', 10, ...
    'MarkerEdgeColor', 'red', ...
    'MarkerFaceColor', [1 .6 .6]);

% Enable the grid
grid on;

% Set labels for the axes
xlabel('relative time (seconds)');
ylabel('sensor value (units)');

% Adjust the current axes
ax = gca;  % Get handle to the current axes

% Set X and Y grid spacing
ax.YTick = floor(min(sensorvalues)):10:ceil(max(sensorvalues));

end


