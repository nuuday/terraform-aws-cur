const AWS = require('aws-sdk');

exports.handler = function(event, context, callback) {
    const glue = new AWS.Glue();
    glue.startCrawler({ Name: process.env.CRAWLER_NAME }, function(err, data) {
        if (err) {
            throw new Error(err);
        }
        else {
            console.log("Successfully triggered crawler");
        }
    });
}
