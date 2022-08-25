class ApiResponse<T> {
  final bool success;
  final T? _data;
  final String? message;

  T get data {
    assert(
      _data != null,
      'Make sure the response is successful before accessing the data',
    );
    return _data!;
  }

  ApiResponse({
    required this.success,
    required T? data,
    this.message,
  }) : _data = data;
}
