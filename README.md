
<h1 align="center">Flow State Controller 🚀</h1>

<p align="center">
  A lightweight state management solution for Flutter that simplifies handling async operation
  <br>
  states (loading, success, error) using reactive streams.
  <br><br>
  <small>
    Show some 👍 and ⭐ <a href="https://github.com/Farid023/flow_state_controller">star the repo</a> to support the project!
  </small>
  <br><br>

  <a href="https://pub.dev/packages/flow_state_controller">
    <img src="https://img.shields.io/pub/v/flow_state_controller.svg" alt="pub package">
  </a>
  <a href="https://github.com/Farid023/flow_state_controller/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="license: MIT">
  </a>
  <a href="https://github.com/Farid023/flow_state_controller/pulls">
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs Welcome">
  </a>
  <br>
</p>



## Installation 📌 

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flow_state_controller: <latest_version>
```
Then, run:
```terminal
flutter pub get
```

## Quick Start 🚀
#### 1. Create Controller

The `FlowStateController` is designed to be mixed into your controller class. This allows your controller to manage asynchronous state (loading, success, and failure) seamlessly.

To get started, create a class that uses the `FlowStateController` mixin.

```dart
class DataController with FlowStateController {
  Future<void> fetchData() async {
    await execute<String>(
      key: 'data_fetch',
      executeData: () => api.getData(),
    );
  }
}
```

In this example:
- The `DataController` class is responsible for managing the state of data fetching.
- The `fetchData()` method calls the `execute()` method, which updates the state to `Loading` while fetching the data and then updates it to either `Success` or `Failure` based on the outcome.


#### 2. Observe State
You can observe the state of the operation by subscribing to the stream with `getStream()`. This will allow you to update the UI based on the current state of the asynchronous operation.
```dart
StreamBuilder<FlowStates<String>>(
  stream: controller.getStream(key: 'data_fetch'),
  builder: (context, snapshot) {
    return snapshot.data?.when(
      loading: () => const CircularProgressIndicator(),
      success: (data) => Text('Data: $data'),
      failure: (error) => Text('Error: $error'),
      orElse: () => const Text('Tap to load'),
    ) ?? const Placeholder();
  },
)
```
In this example:
- The `controller.getStream(key: 'data_fetch')` listens to the stream associated with the key `'data_fetch'`.
- Based on the state (loading, success, failure), the appropriate widget is shown in the UI.

#### 3. Access Current State
If you need to check the current state of the operation without listening to a stream, you can directly access the state using the `currentState` method.
```dart
final currentState = controller.currentState<String>('data_fetch');
currentState.when(
  loading: () => print('Loading...'),
  success: (data) => print('Data: $data'),
  failure: (error) => print('Error: $error'),
  orElse: () => print('Unknown state'),
);
```
Here:
- `controller.currentState<String>('data_fetch')` gives you the current state of the `data_fetch` operation, which you can use to make decisions or updates outside the UI thread.

#### 4. Managing Resources with `disposeFlowStateController`
Once you're done using the `FlowStateController`, make sure to call `disposeFlowStateController()` to release resources and prevent memory leaks.
```dart
@override
void dispose() {
  controller.disposeFlowStateController();
  super.dispose();
}
```
This ensures that all streams are closed, and memory resources are freed when the controller is no longer needed.

## Key Methods
- `getStream<T>`: Returns a stream for the specified key, allowing you to observe the state of asynchronous operations. This is useful for updating the UI when the state changes.

- `currentState<T>`: Retrieves the current state of the asynchronous operation for a given key. This is useful for checking the state immediately without subscribing to the stream.

- `execute<T>`: Executes an asynchronous task, transitions the state between `Loading`, `Success`, and `Failure`, and invokes any provided callbacks (`onSuccess`, `onError`, `onComplete`).

- `disposeFlowStateController`: Disposes of all streams to prevent memory leaks. Call this method when the controller is no longer in use.


## 📃 License
This package is open source and available under the MIT License. See the [LICENSE](https://github.com/Farid023/flow_state_controller/blob/master/LICENSE) file for more information.




## 🐞 Faced issues?

If you encounter any problems or you feel the library is missing a feature, please raise a ticket
on [GitHub](https://github.com/Farid023/flow_state_controller/issues) and I'll look into it.






