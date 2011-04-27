var http = require('http');
var json = JSON;

var OUTPUT = 'source.ssv';

var users_to_get = [ 'shaman_sir',
                     'digal',
                     'crzcrz',
                     'ennoel',
                     'mikashkin',
                     'mcm86',
                     'muromec',
                     'not_existent_one' ];

// constructs http request options from api method and its params
function twi_api(method, params) {
    return {
       host: 'api.twitter.com',
       port: 80,
       path: '/1/' + method + '.json' +
             (params ? ('?' + params) : '')
    };
}

// twitter api responses are streaming, so we need to accumulate them
function acc_stream(res, callback) {
    var body = "";

    res.on('data', function(chunk) {
        body += chunk;
    });

    res.on('end', function() {
        if (callback) callback(json.parse(body));
    });
}

// =============================================================================
// now the magic, requesting all data

for (var i = 0; i < users_to_get.length; i++) {
    var user = users_to_get[i];

    console.log('Requesting data for user ' + user);
    var req = http.get(
        twi_api('users/show', 'screen_name=' + user),
        (function(user) { return function(res) {
            console.log('===================================');
            console.log(user + ' / STATUS: ' + res.statusCode);
        }})(user)
    );

    req.on('response', function(res) {
        if (res.statusCode === 404) return;
        acc_stream(res, function(user_info) {
            console.log('Name: ' + user_info['screen_name']);
            console.log('Geo enabled: ' + user_info['geo_enabled']);
            console.log('Location: ' + user_info['location']);
        });
    });

}

