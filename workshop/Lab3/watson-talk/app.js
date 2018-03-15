
//Add required modules here
var express = require('express');
var request = require('request');
var app = express();
//http://localhost:3000/analyze/hello!

app.get('/', function(req, res) {
 res.send('Ready to take requests and get them analyzed with Watson Tone Analyzer Service!')
})

app.get('/healthz', function(req, res) {
 res.send('OK!')
})

app.get('/analyze/:string', function(req, res) {
       if (!req.params.string) {
           res.status(500);
           res.send({"Error": "You are not sending a valid string to the Watson Service."});
           console.log("You are not sending a valid string to the Watson Service.");
       }
      request.get({ url: "http://watson-service:8081/analyze?text=" + req.params.string },
      function(error, response, body) {
              if (!error && response.statusCode == 200) {
                  res.setHeader('Content-Type', 'application/json');
                  res.send(body);
                 }
             });
     });
app.listen(8080, function() {
       console.log('tone analyzer frontend is listening on port 8080.')
     });
