Application.Services.service("flickerService", ["ngResource"]).factory("flickrPhotos", function ($resource) {
  return $resource('http://api.flickr.com/services/feeds/groups_pool.gne',
    {
      format: 'json',
      id: '40961104@N00',
      jsoncallback: 'JSON_CALLBACK'
    }, {
      'load': {
        'method': 'JSONP'
      }
    }
  );
});