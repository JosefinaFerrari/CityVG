const axios = require("axios").default;
const qs = require("qs");

async function _herokuPreferencesCall(context, ffVariables) {
  var lat = ffVariables["lat"];
  var lng = ffVariables["lng"];
  var radius = ffVariables["radius"];
  var startDate = ffVariables["startDate"];
  var endDate = ffVariables["endDate"];
  var startTime = ffVariables["startTime"];
  var endTime = ffVariables["endTime"];
  var numSeniors = ffVariables["numSeniors"];
  var numAdults = ffVariables["numAdults"];
  var numYouth = ffVariables["numYouth"];
  var numChildren = ffVariables["numChildren"];
  var budget = ffVariables["budget"];
  var categories = ffVariables["categories"];

  var url = `https://cityvg-5fcc7f07e779.herokuapp.com/get_top10/`;
  var headers = {};
  var params = {
    lat: lat,
    lng: lng,
    radius: radius,
    start_date: startDate,
    end_date: endDate,
    start_time: startTime,
    end_time: endTime,
    num_seniors: numSeniors,
    num_adults: numAdults,
    num_youth: numYouth,
    num_children: numChildren,
    budget: budget,
    categories: categories,
  };
  var ffApiRequestBody = undefined;

  return makeApiRequest({
    method: "get",
    url,
    headers,
    params,
    returnBody: true,
    isStreamingApi: false,
  });
}
async function _herokuItinerariesCall(context, ffVariables) {
  var lat = ffVariables["lat"];
  var lng = ffVariables["lng"];
  var radius = ffVariables["radius"];
  var startDate = ffVariables["startDate"];
  var endDate = ffVariables["endDate"];
  var startTime = ffVariables["startTime"];
  var endTime = ffVariables["endTime"];
  var numSeniors = ffVariables["numSeniors"];
  var numAdults = ffVariables["numAdults"];
  var numYouth = ffVariables["numYouth"];
  var numChildren = ffVariables["numChildren"];
  var budget = ffVariables["budget"];
  var requiredPlaces = ffVariables["requiredPlaces"];
  var removedPlaces = ffVariables["removedPlaces"];
  var categories = ffVariables["categories"];

  var url = `https://cityvg-5fcc7f07e779.herokuapp.com/generate/`;
  var headers = {};
  var params = {
    lat: lat,
    lng: lng,
    radius: radius,
    start_date: startDate,
    end_date: endDate,
    start_time: startTime,
    end_time: endTime,
    num_seniors: numSeniors,
    num_adults: numAdults,
    num_youth: numYouth,
    num_children: numChildren,
    budget: budget,
    required_places: requiredPlaces,
    removed_places: removedPlaces,
    categories: categories,
  };
  var ffApiRequestBody = undefined;

  return makeApiRequest({
    method: "get",
    url,
    headers,
    params,
    returnBody: true,
    isStreamingApi: false,
  });
}
async function _herokuImageCall(context, ffVariables) {
  var cityName = ffVariables["cityName"];

  var url = `https://cityvg-5fcc7f07e779.herokuapp.com/city-image/`;
  var headers = {};
  var params = { city_name: cityName };
  var ffApiRequestBody = undefined;

  return makeApiRequest({
    method: "get",
    url,
    headers,
    params,
    returnBody: true,
    isStreamingApi: false,
  });
}

/// Helper functions to route to the appropriate API Call.

async function makeApiCall(context, data) {
  var callName = data["callName"] || "";
  var variables = data["variables"] || {};

  const callMap = {
    HerokuPreferencesCall: _herokuPreferencesCall,
    HerokuItinerariesCall: _herokuItinerariesCall,
    HerokuImageCall: _herokuImageCall,
  };

  if (!(callName in callMap)) {
    return {
      statusCode: 400,
      error: `API Call "${callName}" not defined as private API.`,
    };
  }

  var apiCall = callMap[callName];
  var response = await apiCall(context, variables);
  return response;
}

async function makeApiRequest({
  method,
  url,
  headers,
  params,
  body,
  returnBody,
  isStreamingApi,
}) {
  return axios
    .request({
      method: method,
      url: url,
      headers: headers,
      params: params,
      responseType: isStreamingApi ? "stream" : "json",
      ...(body && { data: body }),
    })
    .then((response) => {
      return {
        statusCode: response.status,
        headers: response.headers,
        ...(returnBody && { body: response.data }),
        isStreamingApi: isStreamingApi,
      };
    })
    .catch(function (error) {
      return {
        statusCode: error.response.status,
        headers: error.response.headers,
        ...(returnBody && { body: error.response.data }),
        error: error.message,
      };
    });
}

const _unauthenticatedResponse = {
  statusCode: 401,
  headers: {},
  error: "API call requires authentication",
};

function createBody({ headers, params, body, bodyType }) {
  switch (bodyType) {
    case "JSON":
      headers["Content-Type"] = "application/json";
      return body;
    case "TEXT":
      headers["Content-Type"] = "text/plain";
      return body;
    case "X_WWW_FORM_URL_ENCODED":
      headers["Content-Type"] = "application/x-www-form-urlencoded";
      return qs.stringify(params);
  }
}

module.exports = { makeApiCall };
