#!/usr/bin/env node


var path = require('path');
var fs = require('fs-extra');
if ( process.argv.length < 3 ) {
    console.error('missing argument.');
    process.exit(1);
    return;
}
var cloud = process.argv[2];

var to = process.cwd();
var from = path.resolve(__dirname);

var copyFolders = [
    'util',
    cloud
];

copyFolders.forEach(function(c){
   fs.copySync( path.join(from,c) , path.join(to,c) );
});



