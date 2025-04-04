import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

part 'flow_states.dart';

/// A mixin class for managing the state of asynchronous operations using streams.
/// It provides functionality for handling loading, success, and failure states for asynchronous tasks.
mixin FlowStateController {
  // A map to store streams associated with specific keys.
  final Map<String, BehaviorSubject<FlowStates<dynamic>>> _streams = {};

  /// Returns a stream of states for the specified key.
  /// If the stream does not exist, an exception is thrown.
  ///
  /// [T] specifies the type of data that the stream will manage.
  Stream<FlowStates<T>> getStream<T>({required String key}) {
    // Ensure the stream for the specified key exists before accessing it.
    if (!_streams.containsKey(key)) {
      Error.throwWithStackTrace(
        Exception(
            "Stream with key '$key' does not exist. Please initialize the stream first."),
        StackTrace.current,
      );
    }

    // Return the stream for the specified key, casting it to the appropriate type.
    return _streams[key]!.stream.cast<FlowStates<T>>();
  }

  /// Returns the current state for the specified key.
  /// If the stream does not exist, an exception is thrown.
  ///
  /// [T] specifies the type of data that the stream holds.
  FlowStates<T> currentState<T>(String key) {
    // Check if the stream exists for the given key. This is an assertion to ensure no misuse.
    assert(!_streams.containsKey(key),
        "Stream with key '$key' does not exist. Please initialize the stream first.");

    // If the stream doesn't exist, throw an error with a stack trace.
    if (!_streams.containsKey(key)) {
      Error.throwWithStackTrace(
        Exception(
            "Stream with key '$key' does not exist. Please initialize the stream first."),
        StackTrace.current,
      );
    }

    // Return the current value of the stream, casting it to the appropriate type.
    return _streams[key]!.value as FlowStates<T>;
  }

  /// An asynchronous method for fetching data.
  ///
  /// This method sets the state to `loading`, fetches the data asynchronously, and then updates the state
  /// based on whether the data fetching is successful or encounters an error.
  ///
  /// [key] is the identifier for the stream that will hold the result of the operation.
  ///
  /// [executeData] is the function that performs the async operation (such as fetching data from an API).
  /// It returns a `Future<T?>`, where `T` is the data type that will be fetched.
  ///
  /// [onSuccess] is an optional callback that will be called if the data fetching is successful.
  /// It takes the fetched data (`T? data`) as an argument.
  ///
  /// [onError] is an optional callback that will be called if the data fetching encounters an error.
  /// It takes the error (`Object? error`) and stack trace (`StackTrace? stackTrace`) as arguments.
  ///
  /// [onComplete] is an optional callback that will always be called when the operation completes, whether it succeeds or fails.
  Future<void> execute<T>({
    // Unique key for the stream associated with this task
    required String key,
    // The function that executes the async task
    required Future<T?> Function() executeData,
    // Callback to handle success
    Future<void> Function(T? data)? onSuccess,
    // Callback to handle error
    Future<void> Function(Object? error, StackTrace? stackTrace)? onError,
    // Callback to execute once the task completes
    Future<void> Function()? onComplete,
  }) async {
    // Ensure the stream for the given key exists. If it does not, initialize it.
    _initStream<T>(key);
    final subject = _streams[key]! as BehaviorSubject<FlowStates<T>>;

    try {
      // Set the state to 'loading' to indicate the async task is in progress.
      subject.add(Loading<T>());

      // Execute the process (fetch data or execute task)
      final result = await executeData();

      // Call onSuccess with result (can be null)
      await onSuccess?.call(result);

      // Set the state to 'success' with the fetched data.
      subject.add(Success<T>(data: result));
    } catch (e, s) {
      // If an error occurs, set the state to 'failure' with the error message.
      subject.add(Failure<T>(message: "$e"));
      // If an error callback is provided, invoke it with the error details.
      await onError?.call(e, s);
    } finally {
      // Regardless of success or failure, invoke the 'onComplete' callback.
      await onComplete?.call();
    }
  }

  /// Initializes a stream for the specified key.
  ///
  /// This method ensures that each key has a stream associated with it.
  /// If the stream already exists, it will not be reinitialized, preventing unnecessary operations.
  ///
  /// [T] specifies the type of data the stream will hold.
  ///
  /// [key] is the identifier for the stream.
  void _initStream<T>(String key) {
    // If the stream doesn't already exist for the key, initialize it with an initial state.
    if (!_streams.containsKey(key)) {
      _streams[key] = BehaviorSubject<FlowStates<T>>.seeded(Initial<T>());
    }
  }

  /// Disposes all streams to prevent memory leaks.
  ///
  /// This method should be called when the streams are no longer needed, typically when the app or service
  /// is disposed of, to release resources and avoid memory leaks.
  void disposeFlowStateController() {
    // Close each stream and release its resources.
    _streams.forEach((_, subject) => subject.close());
    // Clear the map of streams.
    _streams.clear();
  }
}
