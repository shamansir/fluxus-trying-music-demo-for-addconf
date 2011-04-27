var http = require('http');

var twi_api = function(method, params) {
    return {
       host: 'api.twitter.com',
       port: 80,
       path: '/1/' + method + '.json' +
             (params ? ('?' + params) : '')
    };
}

var req = http.get(
    twi_api('users/show', 'screen_name=shaman_sir'),
    function(res) {
        console.log('STATUS: ' + res.statusCode);
        console.log('HEADERS: ' + JSON.stringify(res.headers));

        res.on('data', function(d) {
            process.stdout.write(d);
        });
    }
);

