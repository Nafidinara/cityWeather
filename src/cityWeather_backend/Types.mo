module Types {

    public type Timestamp = Nat64;

    // Defines the Type that describes the Request arguments for an HTTPS outcall.
    public type HttpRequestArgs = {
        url : Text;
        max_response_bytes : ?Nat64;
        headers : [HttpHeader];
        body : ?[Nat8];
        method : HttpMethod;
        transform : ?TransformRawResponseFunction;
    };

    public type HttpHeader = {
        name : Text;
        value : Text;
    };

    public type HttpMethod = {
        #get;
        #post;
        #head;
    };

    public type HttpResponsePayload = {
        status : Nat;
        headers : [HttpHeader];
        body : [Nat8];
    };

    // Defines a function called 'TransformRawResponse', used in the HttpRequestArgs.
    public type TransformRawResponseFunction = {
        function : shared query TransformArgs -> async CanisterHttpResponsePayload;
        context : Blob;
    };

    // Defines the arguments the transform function needs.
    public type TransformArgs = {
        response : HttpResponsePayload;
        context : Blob;
    };

    public type CanisterHttpResponsePayload = {
        status : Nat;
        headers : [HttpHeader];
        body : [Nat8];
    };

    public type TransformContext = {
        function : shared query TransformArgs -> async CanisterHttpResponsePayload;
        context : Blob;
    };

    // Management canister type declaration for making HTTPS outcalls.
    public type IC = actor {
        http_request : HttpRequestArgs -> async HttpResponsePayload;
    };

}