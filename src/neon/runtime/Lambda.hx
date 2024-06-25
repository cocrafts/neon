package neon.runtime;

typedef LambdaContext = {
	var functionName:String;
	var functionVersion:String;
	var memoryLimitInMb:Int;
	var logGroupName:String;
	var logStreamName:String;
	var awsRequestId:String;
	var involkedFunctionArn:String;
	// var deadline:Time;
	// var identity:JsonNode;
}

class Lambda {
	public var context:LambdaContext;
	private var runtimeBase:String;

	public function start(handler: (event:Dynamic, context:LambdaContext)->Dynamic) {
		var result = handler(null, null);
		trace(context, "<-- context");
		trace(result, "<-- from here!");

		var res = haxe.Http.requestUrl('${runtimeBase}/invocation/next');
		trace(res);
	}

	public function new() {
		var memorySize = Sys.getEnv("AWS_LAMBDA_FUNCTION_MEMORY_SIZE");
		var runtimeApi = Sys.getEnv("AWS_LAMBDA_RUNTIME_API");

		context = {
			functionName: Sys.getEnv("AWS_LAMBDA_FUNCTION_NAME"),
			functionVersion: Sys.getEnv("AWS_LAMBDA_FUNCTION_VERSION"),
			memoryLimitInMb: memorySize == null ? 256 : Std.parseInt(memorySize),
			logGroupName: Sys.getEnv("AWS_LAMBDA_LOG_GROUP_NAME"),
			logStreamName: Sys.getEnv("AWS_LAMBDA_LOG_STREAM_NAME"),
			awsRequestId: "",
			involkedFunctionArn: "",
		};

		runtimeBase = 'http://${runtimeApi}/2018-06-01/runtime';
	}	
}

