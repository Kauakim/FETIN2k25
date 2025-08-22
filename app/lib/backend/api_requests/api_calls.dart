import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

class UserLoginCall {
  static Future<ApiCallResponse> call({
    String? username = '',
    String? password = '',
  }) async {
    final ffApiRequestBody = '''
      {
        "username": "[username]",
        "password": "[password]"
      }
    ''';
    return ApiManager.instance.makeApiCall(
      callName: 'UserLogin',
      apiUrl: 'http://127.0.0.1:5501/users/login',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }
}

class UserSigninCall {
  static Future<ApiCallResponse> call({
    required String username,
    required String password,
    required String email,
    required String role,
  }) async {
    final ffApiRequestBody = '''
      {
        "username": "$username",
        "password": "$password",
        "email": "$email",
        "role": "$role"
      }
    ''';
    return ApiManager.instance.makeApiCall(
      callName: 'UserSignin',
      apiUrl: 'http://127.0.0.1:5501/users/signin',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }
}

class UserUpdateCall {
  static Future<ApiCallResponse> call({
    required String oldUsername,
    required String newUsername,
    required String password,
    required String email,
    required String role,
  }) async {
    final ffApiRequestBody = '''
      {
        "oldUsername": "$oldUsername",
        "newUsername": "$newUsername",
        "password": "$password",
        "email": "$email",
        "role": "$role"
      }
    ''';
    return ApiManager.instance.makeApiCall(
      callName: 'UserUpdate',
      apiUrl: 'http://127.0.0.1:5501/users/update',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }
}

class UserDeleteCall {
  static Future<ApiCallResponse> call({
    required String username,
  }) async {
    final ffApiRequestBody = '''
      {
        "username": "$username"
      }
    ''';
    return ApiManager.instance.makeApiCall(
      callName: 'UserDelete',
      apiUrl: 'http://127.0.0.1:5501/users/delete',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }
}

class BeaconsGetAllCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'BeaconsGetAll',
      apiUrl: 'http://127.0.0.1:5501/beacons/get/all',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
    );
  }
}

class BeaconsGetRecentCall {
  static Future<ApiCallResponse> call({
    required int seconds,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'BeaconsGetRecent',
      apiUrl: 'http://127.0.0.1:5501/beacons/get/$seconds',
      callType: ApiCallType.GET,
      headers: {},
      returnBody: true,
    );
  }
}

class InfoGetCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'InfoGet',
      apiUrl: 'http://127.0.0.1:5501/info',
      callType: ApiCallType.GET,
      headers: {},
      returnBody: true,
    );
  }
}

class InfoCreateCall {
  static Future<ApiCallResponse> call({
    required String maquina,
    required int tasksConcluidas,
    required int tasksCanceladas,
    required double horasTrabalhadas,
    required String data,
  }) async {
    final ffApiRequestBody = '''
      {
        "maquina": "$maquina",
        "tasksConcluidas": $tasksConcluidas,
        "tasksCanceladas": $tasksCanceladas,
        "horasTrabalhadas": $horasTrabalhadas,
        "data": "$data"
      }
    ''';
    return ApiManager.instance.makeApiCall(
      callName: 'InfoCreate',
      apiUrl: 'http://127.0.0.1:5501/info/create',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }
}

class InfoUpdateCall {
  static Future<ApiCallResponse> call({
    required String maquina,
    required int tasksConcluidas,
    required int tasksCanceladas,
    required double horasTrabalhadas,
    required String data,
  }) async {
    final ffApiRequestBody = '''
      {
        "maquina": "$maquina",
        "tasksConcluidas": $tasksConcluidas,
        "tasksCanceladas": $tasksCanceladas,
        "horasTrabalhadas": $horasTrabalhadas,
        "data": "$data"
      }
    ''';
    return ApiManager.instance.makeApiCall(
      callName: 'InfoUpdate',
      apiUrl: 'http://127.0.0.1:5501/info/update',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }
}

class InfoDeleteCall {
  static Future<ApiCallResponse> call({
    required String maquina,
    required String data,
  }) async {
    final ffApiRequestBody = '''
      {
        "maquina": "$maquina",
        "data": "$data"
      }
    ''';
    return ApiManager.instance.makeApiCall(
      callName: 'InfoDelete',
      apiUrl: 'http://127.0.0.1:5501/info/delete',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}
