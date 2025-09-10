import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const String apiBaseUrl = 'http://192.168.0.109:5501';

class UserLoginCall {
  static Future<ApiCallResponse> call({
    String? username = '',
    String? password = '',
  }) async {
    final ffApiRequestBody = '''
      {
        "username": "$username",
        "password": "$password"
      }
    ''';
    return ApiManager.instance.makeApiCall(
      callName: 'UserLogin',
      apiUrl: '${apiBaseUrl}/users/login/',
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
      apiUrl: '${apiBaseUrl}/users/signin/',
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
      apiUrl: '${apiBaseUrl}/users/update/',
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
      apiUrl: '${apiBaseUrl}/users/delete/',
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
      apiUrl: '${apiBaseUrl}/beacons/get/all/',
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
      apiUrl: '${apiBaseUrl}/beacons/get/$seconds/',
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
      apiUrl: '${apiBaseUrl}/info/',
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
      apiUrl: '${apiBaseUrl}/info/create/',
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
      apiUrl: '${apiBaseUrl}/info/update/',
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
      apiUrl: '${apiBaseUrl}/info/delete/',
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

class TasksGetAllCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'TasksGetAll',
      apiUrl: '${apiBaseUrl}/tasks/read/all/',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
    );
  }
}

class TasksGetByUserCall {
  static Future<ApiCallResponse> call({
    required String username,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'TasksGetByUser',
      apiUrl: '${apiBaseUrl}/tasks/read/$username/',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
    );
  }
}

class TasksCreateCall {
  static Future<ApiCallResponse> call({
    required String mensagem,
    required String destino,
    required String tipoDestino,
    required List<String> beacons,
    required List<String> dependencias,
    required String tipo,
    required String status,
  }) async {
    final ffApiRequestBody = '''
      {
        "mensagem": "$mensagem",
        "destino": "$destino",
        "tipoDestino": "$tipoDestino",
        "beacons": [${beacons.map((e) => '"$e"').join(', ')}],
        "dependencias": [${dependencias.map((e) => '"$e"').join(', ')}],
        "tipo": "$tipo",
        "status": "$status"
      }
    ''';
    return ApiManager.instance.makeApiCall(
      callName: 'TasksCreate',
      apiUrl: '${apiBaseUrl}/tasks/create/',
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

class TasksUpdateCall {
  static Future<ApiCallResponse> call({
    required int id,
    required String user,
    required String mensagem,
    required String destino,
    required String tipoDestino,
    required List<String> beacons,
    required List<String> dependencias,
    required String tipo,
    required String status,
  }) async {
    final ffApiRequestBody = '''
      {
        "id": $id,
        "user": "$user",
        "mensagem": "$mensagem",
        "destino": "$destino",
        "tipoDestino": "$tipoDestino",
        "beacons": [${beacons.map((e) => '"$e"').join(', ')}],
        "dependencias": [${dependencias.map((e) => '"$e"').join(', ')}],
        "tipo": "$tipo",
        "status": "$status"
      }
    ''';
    return ApiManager.instance.makeApiCall(
      callName: 'TasksUpdate',
      apiUrl: '${apiBaseUrl}/tasks/update/',
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

class UsersGetAllCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'UsersGetAll',
      apiUrl: '${apiBaseUrl}/users/get/all/',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
    );
  }
}

class TasksListCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'TasksList',
      apiUrl: '${apiBaseUrl}/tasks/read/all/',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
    );
  }
}

class InfoGetAllCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'InfoGetAll',
      apiUrl: '${apiBaseUrl}/info/',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
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
