part of 'flow_state_controller.dart';

/// A sealed class representing the different states of an asynchronous operation.
/// This class serves as the base class for the other state types (Initial, Loading, Success, Failure).
/// It provides a common interface for all states, ensuring that the derived states adhere to the same structure.
@immutable
sealed class FlowStates<T> extends Equatable {
  const FlowStates();

  /// Returns a list of properties for comparison in Equatable, allowing states to be compared for equality.
  @override
  List<Object?> get props => [];
}

/// Represents the initial state of the operation.
/// This state typically indicates that no action has been taken yet, or data is yet to be fetched.
final class Initial<T> extends FlowStates<T> {}

/// Represents the loading state of the operation.
/// This state indicates that data is being fetched or some task is in progress.
/// It is typically used to show loading indicators in the UI.
final class Loading<T> extends FlowStates<T> {}

/// Represents the successful state of the operation, containing the result of the operation.
/// The `data` field holds the actual result (can be null).
/// This state is used to convey that the operation completed successfully and data is available.
final class Success<T> extends FlowStates<T> {
  /// Creates an instance of [Success] with the provided [data].
  const Success({required this.data});

  /// The result of the operation, can be null.
  final T? data;

  /// Returns a list of properties for comparison, including the `data` field.
  @override
  List<Object?> get props => [data];
}

/// Represents the failure state of the operation, containing an error message.
/// The `message` field holds the error message explaining why the operation failed.
/// This state is used to convey that something went wrong during the operation.
final class Failure<T> extends FlowStates<T> {
  /// Creates an instance of [Failure] with the provided [message].
  const Failure({this.message});

  /// The error message associated with the failure, can be null.
  final String? message;

  /// Returns a list of properties for comparison, including the `message` field.
  @override
  List<Object?> get props => [message];
}
