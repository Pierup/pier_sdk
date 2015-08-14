var log4js = require('log4js');
var time = require('./pierutil/util').getCurrentDate();
var pierLog;
//config for the log file
log4js.configure({
  appenders: [
      {
          type: "file",//"file",
          filename: "./log/"+time+".log",
          category: [ "./log/"+time,"console" ]
      },
      {
          type: "console"
      }
  ],
  replaceConsole: true
});

log4js.loadAppender('file');
pierLog = log4js.getLogger("./log/"+time);
//only errors and above get logged.
//you can also set this log level in the config object
//via the levels field.
pierLog.setLevel('INFO');
module.exports = pierLog;