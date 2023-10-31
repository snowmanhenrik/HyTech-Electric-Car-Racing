function [] = bucketquery()

base_url = 'http://3.134.2.166:8086';
token = 'cBzX7hK34AHjfGCElheFna0jT39u5j_Ebi4vRYWDZP1E-LjAffa7hj85pavKbCp71_6nzpCBQxje-YeGRf4UfQ==';

endpoint = '/api/v2/buckets';

options = weboptions('RequestMethod', 'GET', ...
                     'MediaType', 'application/json', ...
                     'HeaderFields', {'Authorization', ['Token ' token]});

    response = webread([base_url endpoint], options);

for i = 1:length(response.buckets)
    disp(['Bucket Name: ' response.buckets{i}.name ' | Bucket ID: ' response.buckets{i}.id]);
end
end



