const Test = require('../model/test');

module.exports.getInvestors = (event, context, callback) => {
  console.log('hello');
  console.log(`event:${event}`);
  console.log(`context:${context}`);
  Test.console();
  callback(null, 'OK');
};

module.exports.getInvestorById = (event, context, callback) => {
  console.log('Id');
  console.log(`event:${event}`);
  console.log(`context:${context}`);
  Test.console();
  const data = {
    res: 'OK',
  };
  const response = {
    statusCode: 200,
    headers: {
      'Access-Control-Allow-Origin': '*', // Required for CORS support to work
    },
    body: JSON.stringify(data),
  };
  callback(null, response);
};
