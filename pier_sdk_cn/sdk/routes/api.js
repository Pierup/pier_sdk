var express = require('express');
var router = express.Router();
var request = require('request');
var apiUrl = require( '../config/apiUrl' );
var pierUtil = require( '../pierutil/util' );
var pierLog = require( '../pierlog' );


router.post('/*', function(req, res, next) {
  var urlPath = req.path;
  request( pierUtil.getRequestParams( urlPath, req.body ), function(err, response, body){
  	console.log( "get response body", body );
  	res.send( body );
  } );
});
module.exports = router;