package neon.runtime;

import haxe.Json;
import tink.http.Client.*;

typedef LambdaContext = {
	var functionName:String;
	var functionVersion:String;
	var logGroupName:String;
	var logStreamName:String;
	var awsRequestId:String;
	var memoryLimitInMb:Int;
	var involkedFunctionArn:String;
	var deadline:Date;
	var identity:Json;
	var clientContext:Json;
}

class Lambda {
	public var context:LambdaContext;
	private var runtimeBase:String;
	private var memorySize:Int = 256;

	public function start(handler: (event:Dynamic, context:LambdaContext)->Dynamic) {
		while (true) { /* this is a must for Lambda runtime, keep the Manager always ready to serve.. */
			var requestId:String = "";

			fetch('${runtimeBase}/invocation/next').all()
				.handle(function(o) switch o {
					case Success(res): {
						requestId = res.header.get("lambda-runtime-aws-request-id")[0];

						var event = Json.parse(res.body.toString());
						var traceId = res.header.get("lambda-runtime-trace-id")[0];
						var functionArn = res.header.get("lambda-runtime-invoked-function-arn")[0];
						var clientContextRaw = res.header.get("lambda-runtime-client-context")[0];
						var identityRaw = res.header.get("lambda-runtime-cognito-identity")[0];
						var deadlineRaw = res.header.get("lambda-runtime-deadline-ms")[0];
						var deadlineMs = deadlineRaw == null ? 0 : Std.parseFloat(deadlineRaw);

						Sys.putEnv("_X_AMZN_TRACE_ID", traceId);

						context = {
							functionName: Sys.getEnv("AWS_LAMBDA_FUNCTION_NAME"),
							functionVersion: Sys.getEnv("AWS_LAMBDA_FUNCTION_VERSION"),
							logGroupName: Sys.getEnv("AWS_LAMBDA_LOG_GROUP_NAME"),
							logStreamName: Sys.getEnv("AWS_LAMBDA_LOG_STREAM_NAME"),
							awsRequestId: requestId,
							memoryLimitInMb: memorySize, 
							involkedFunctionArn: functionArn,
							deadline: Date.fromTime(deadlineMs),
							identity: identityRaw == null ? null : Json.parse(identityRaw), 
							clientContext: clientContextRaw == null ? null : Json.parse(clientContextRaw),
						}

						var response = handler(event, context);
						var http = new haxe.Http('${runtimeBase}/invocation/${requestId}/response');

						if (Reflect.isObject(response)) {
							http.setHeader("Content-Type", "application/json");
							http.setPostData(Json.stringify(response));
						} else {
							http.setPostData(response);
						}

						http.request(true);
					}
					case Failure(e): {
						var http = new haxe.Http('${runtimeBase}/invocation/${requestId}/error');

						http.setHeader("Content-Type", "application/json");
						http.setPostData(Json.stringify({
							errorType: "WIP",
							errorMessage: e.toString(), 
						}));
						http.request(true);
					};
				});
		}
	}

	public function new() {
		var memSize = Sys.getEnv("AWS_LAMBDA_FUNCTION_MEMORY_SIZE");
		var runtimeApi = Sys.getEnv("AWS_LAMBDA_RUNTIME_API");

		memorySize = memSize == null ? 256 : Std.parseInt(memSize);
		runtimeBase = 'http://${runtimeApi}/2018-06-01/runtime';
	}	
}

