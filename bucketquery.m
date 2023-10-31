function [] = bucketquery()

base_url = 'http://3.134.2.166:8086';
token = '<token>';
%replace <token> with actual access token.

endpoint = '/api/v2/buckets';

options = weboptions('RequestMethod', 'GET', ...
                     'MediaType', 'application/json', ...
                     'HeaderFields', {'Authorization', ['Token ' token]});

    response = webread([base_url endpoint], options);

for i = 1:length(response.buckets)
    disp(['Bucket Name: ' response.buckets{i}.name ' | Bucket ID: ' response.buckets{i}.id]);
end
end



