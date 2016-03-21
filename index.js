#!/usr/bin/env node

var path = require('path');
var fs = require('fs-extra');
//defining arguments
var argv = require('yargs')
    .option('cloud', {
        alias: 'c'
    })
    .option('args', {
        alias: 'a',
        type: 'array'
    })
    .argv;

//validating arguments
if( !argv.cloud || typeof argv.cloud !== 'string' ){
    console.error(argv.cloud && typeof argv.cloud !== 'string' ? 'Cloud argument must be a string' : 'Must pass cloud as an argument (--cloud)');
    process.exit(1);
}

var cloud = argv.cloud;
var args = argv.args;
var to = process.cwd();
var from = path.resolve(__dirname);

//copy folders
var copyFolders = [
    'util',
    cloud
];

copyFolders.forEach(function(c){
   fs.copySync( path.join(from,c) , path.join(to,c) );
});

//add args to vagrantfile
if(args && args.length > 0){
    var vagrantfile = path.join(to,cloud,'/Vagrantfile');

    var body = fs.readFileSync(vagrantfile).toString();
    var lines = body.split('\n');
    var appended = false;

    var configFileDeclaration = "CONFIG_FILE = ENV['CONFIG_FILE']";

    function appendAfter (lines, search, append) {
        for(var i = 0 ; i < lines.length; i++){
            var index = lines[i].indexOf(search);
            if(index !== -1){
                //index is count of whitespaces for indentation
                append = Array(index+1).join(" ")+append;
                lines.splice(i+1,0,append);
                appended = true;
                break;
            }
        }
    }

    function declareVariable(variable){
        var argDeclaration = variable+" = ENV['"+variable+"']";
        appendAfter(lines, configFileDeclaration, argDeclaration);
    }

    for(var i=0; i<args.length; i++){
        declareVariable(args[i]);
    }

    (function declareArgs(args){
        var provisionScriptDeclaration = "s.path = \"../provision.sh\"";
        var argsString = "";
        args.forEach(function(arg){
            argsString += argsString === "" ? "" : " ";
            argsString += "#{"+arg+"}"
        });
        var provisionArgsDeclaration = "s.args = \""+argsString+"\"";

        appendAfter(lines, provisionScriptDeclaration, provisionArgsDeclaration);
    })(args);


    if(appended){
        body = lines.join('\n');
        fs.writeFileSync(vagrantfile, body);
    }
}