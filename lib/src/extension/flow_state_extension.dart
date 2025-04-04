import '../flow_state_controller.dart';

/// An extension on `FlowStates<T>` to allow easy pattern matching on the state.
/// This extension adds the `when` method to `FlowStates<T>`, enabling you to handle different
/// states (Loading, Success, Failure) in a functional style with the appropriate callback functions.
///
/// The `when` method is designed to allow different actions based on the state type.
/// It provides a convenient way to deal with various states without needing a series of if-else checks.
extension FlowStateExtensions<T> on FlowStates<T> {
  /// A method for pattern matching on the `FlowStates<T>`.
  ///
  /// This method lets you execute different actions depending on the current state (Loading, Success, Failure).
  ///
  /// [loading] is called when the state is `Loading`.
  /// [success] is called when the state is `Success<T>`. It provides the `data` (of type `T?`), which can be `null`.
  /// [failure] is called when the state is `Failure`. It provides the error message (`String? message`).
  /// [orElse] is a fallback function, which is executed if the state is not one of the predefined types (`Loading`, `Success`, or `Failure`).
  /// Typically, this could be used as a catch-all for unexpected states.
  ///
  /// Returns the result of the respective function based on the current state.
  R when<R>({
    required R Function() loading, // Action for the loading state
    required R Function(T? data)
        success, // Action for the success state, with the result data
    required R Function(String? message)
        failure, // Action for the failure state, with the error message
    required R Function() orElse, // A fallback for unexpected or unknown states
  }) {
    // Check if the current state is 'Loading', if true, call the `loading` callback.
    if (this is Loading) {
      return loading();
    }
    // Check if the current state is 'Success', if true, call the `success` callback with the associated data.
    else if (this is Success<T>) {
      return success((this as Success<T>).data);
    }
    // Check if the current state is 'Failure', if true, call the `failure` callback with the associated error message.
    else if (this is Failure) {
      return failure((this as Failure).message);
    }
    // If the state is not one of the above, return the result from the `orElse` function.
    else {
      return orElse();
    }
  }
}
