import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Text "mo:base/Text";
import Types "Types";

actor {

    public query func transform(raw : Types.TransformArgs) : async Types.CanisterHttpResponsePayload {
        let transformed : Types.CanisterHttpResponsePayload = {
            status = raw.response.status;
            body = raw.response.body;
            headers = [
                {
                    name = "Content-Security-Policy";
                    value = "default-src 'self'";
                },
                { name = "Referrer-Policy"; value = "strict-origin" },
                { name = "Permissions-Policy"; value = "geolocation=(self)" },
                {
                    name = "Strict-Transport-Security";
                    value = "max-age=63072000";
                },
                { name = "X-Frame-Options"; value = "DENY" },
                { name = "X-Content-Type-Options"; value = "nosniff" },
            ];
        };
        transformed;
    };

    public func get_weather(city: Text) : async Text {

        let ic : Types.IC = actor ("aaaaa-aa");

        let host : Text = "goweather.herokuapp.com";
        let url = "https://" # host # "/weather/" # city;

        let request_headers = [
            { name = "Host"; value = host # ":443" },
            { name = "User-Agent"; value = "weather_canister" },
        ];

        let transform_context : Types.TransformContext = {
            function = transform;
            context = Blob.fromArray([]);
        };

        let http_request : Types.HttpRequestArgs = {
            url = url;
            max_response_bytes = null; // Optional for request
            headers = request_headers;
            body = null; // Optional for request
            method = #get;
            transform = ?transform_context;
        };

        // Add cycles to cover the cost of the HTTP request
        Cycles.add(20_949_972_000);

        // Make the HTTP request and retrieve the response
        let http_response : Types.HttpResponsePayload = await ic.http_request(http_request);

        // Decode the response body from Blob to Text
        let response_body: Blob = Blob.fromArray(http_response.body);
        let decoded_text: Text = switch (Text.decodeUtf8(response_body)) {
            case (null) { "No value returned" };
            case (?y) { y };
        };

        decoded_text
    };
    
}