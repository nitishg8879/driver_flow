abstract class Routes {
  Routes._();
  static const splash = _Paths.splash;
  static const login = _Paths.login;
  static const root = _Paths.root;
  static const dashboard = _Paths.dashboard;
  static const students = _Paths.students;
  static const instructors = _Paths.instructors;
  static const vehicles = _Paths.vehicles;
  static const vehicleTypes = _Paths.vehicleTypes;
  static const schedule = _Paths.schedule;
}

abstract class _Paths {
  _Paths._();
  static const splash = '/';
  static const login = '/login';
  static const root = '/root';
  static const dashboard = '/dashboard';
  static const students = '/students';
  static const instructors = '/instructors';
  static const vehicles = '/vehicles';
  static const vehicleTypes = '/vehicle-types';
  static const schedule = '/schedule';
}
