var http = require('http');
var fs = require('fs');
var json = JSON;

var OUTPUT = './source.ssv';

var results = {}; // object of { '<screen_name>':
                  //                 { 'name': '...',
                  //                   'location': '...',
                  //                   'followers_num': ...,
                  //                   'tweets_num': ...,
                  //                   'tweets': [ '...', '...' ]
                  //                   'followers': [ '...', '...' ]
                  //                 }, ...
                  //           }

var users_to_get = [ 'shaman_sir',
                     'digal',
                     '8crz',
                     'ennoel',
                     'mikashkin',
                     /* 'mcm69',
                     'ilyamuromec',
                     'shergin',
                     'pipopolam',
                     'experika',
                     'lazio_od',
                     'mihailkukuruza',
                     'akella',
                     'dudnik',
                     'gvanrossum',
                     'curlybrace',
                     'not_existent_one' */ ];

// =============================================================================
// twitter api utils

// constructs http request options from api method and its params
function twi_api(method, params) {
    return {
       host: 'api.twitter.com',
       port: 80,
       path: '/1/' + method + '.json' +
             (params ? ('?' + params) : '')
    };
}

// twitter api responses are streaming ones, so we need to accumulate them
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
// chain of calls to twitter api

function __add(method, params, ok_callback, pre_callback) {
    this.calls.push({ 'method' : method,
                      'params' : params,
                      'ok_callback': ok_callback,
                      'pre_callback': pre_callback });
    return this;
}

function __perform(idx) {
    var cur_call = idx || 0;
    if (cur_call < this.calls.length) {
        var _call = this.calls[cur_call];

        var req = http.get(
            twi_api(_call.method, _call.params),
            function(res) {
                _call.pre_callback(_call, res);
            });

        var ctx = this;
        req.on('response', function(res) {
            if (res.statusCode === 404) return;
            acc_stream(res, (function(ctx, cur_call) {
                return function(data) {
                    _call.ok_callback(data);
                    __perform.call(ctx, ++cur_call);
                }
            })(ctx, cur_call));
        });
    }

    return this;
}

function TwiApiChain() {
    return { 'add': __add, 'perform': __perform, 'calls': [] };
}

// =============================================================================
// now the magic, requesting all data

function store_user_info(user_info) {
    results[user_info['screen_name']] = {
        'name': user_info['name'],
        'location': user_info['location'],
        'followers_num': user_info['followers_count'],
        'tweets_num': user_info['statuses_count']
    };
    console.log('> Got info for : ' + user_info['screen_name']);
}

function store_statuses(user, statuses) {
    if (!results[user]) return;
    results[user]['tweets'] = null;
    if (!statuses) return;
    var acc = [];
    for (var i = 0; i < statuses.length; i++) {
        acc.push(statuses[i].text);
    }
    results[user]['tweets'] = acc;
    console.log('> Got tweets for : ' + user);
}

function save_results_to_file() {
    console.log('> Time to save results');

    var stream = fs.createWriteStream(OUTPUT);

    for (var uid in results) {
        //if (!results.hasOwnProperty(user)) return;
        var user = results[uid];
        stream.write('"' + uid + '" ' +
                     '"' + user.name + '" ' +
                     '"' + user.location + '" ' +
                     user.followers_num + ' ' +
                     user.tweets_num);
        if (user.tweets.length > 0) {
            stream.write(' ');
            for (var i = 0; i < user.tweets.length; i++) {
                stream.write('"' + user.tweets[i].replace(/\"/g, '`')
                                                 .replace(/\r?\n|\r/g, ' ')
                                                 .replace(/\\/g, '|') + '" ');
            }
        }
        stream.write('\n');
    }

    stream.end();
}

// ================================== main() ===================================

function main() {
    for (var i = 0; i < users_to_get.length; i++) {
        var user = users_to_get[i];

        console.log('Requesting data for user ' + user);

        var chain = new TwiApiChain();

        var before = (function(user) { return function(call_, res) {
            console.log('> Call:', call_.method + '?' + call_.params);
            console.log('>> ' + user + ' / STATUS: ' + res.statusCode);
            if (res.statusCode !== 200) throw 'Failed to get ' + user + ' info';
        }})(user);

        chain.add('users/show',
                  'screen_name=' + user,
                  store_user_info,
                  before)
             .add('statuses/user_timeline',
                  'screen_name=' + user,
                  (function(user, i) { return function(data) {
                      store_statuses(user, data);
                      if (i === (users_to_get.length - 1)) { // received all
                         save_results_to_file();
                      }
                  }})(user, i),
                  before)
             .perform();
    }
}

main();

