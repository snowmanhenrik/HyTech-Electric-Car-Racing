function [] = getdata()
bucketquery()

x = []; % initializing containing timestamps array.
y = []; % initializing sensor values array.

getData()


end

function data = getData()

prompt1 = "Please input the *name* of the bucket you want to query: ";

bucketname = input(prompt1,'s');

% 1. Define the Query and Parameters
fluxQueryf = 'from(bucket: "';
%fluxQueryb = '") |> range(start: -7d, stop: now()) |> aggregateWindow(every:(1d),fn:mean,createEmpty: false) |> yield(name: "mean")';
fluxQueryb = '") |> range(start: -7d, stop: now()) |> filter(fn: (r) => r["_measurement"] == "detailed_temps") |> filter(fn: (r) => r["_field"] == "ic_00") |> filter(fn: (r) => r["id"] == "temp_1") |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false) |> yield(name: "mean")';
fluxQuery = [fluxQueryf bucketname fluxQueryb];

disp(fluxQuery);

% 2. Construct the Request Body
requestBody = struct('query', fluxQuery);

% 3. Set HTTP Options and Headers
headers = matlab.net.http.HeaderField('authorization', 'Token <token>', 'content-type', 'application/vnd.flux');
% replace <token> with actual access token
request = matlab.net.http.RequestMessage('POST', headers, jsonencode(requestBody));

% 4. Send the Request using webread
url = 'http://3.134.2.166:8086/api/v2/query?org=4a7a666528409094';

try
    response = request.send(url).Body.Data;
    disp(response);

    % 5. Handle the Response (for now, just display it)

catch exception
    % 6. Error Handling
    disp('Error encountered:');
    disp(exception.message);

end

end






