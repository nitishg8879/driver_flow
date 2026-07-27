abstract class Routes {
  Routes._();
  static const splash = _Paths.splash;
  static const login = _Paths.login;
  static const root = _Paths.root;
  static const dashboard = _Paths.dashboard;
  static const users = _Paths.users;
  static const vehicles = _Paths.vehicles;
  static const vehicleTypes = _Paths.vehicleTypes;
  static const schedule = _Paths.schedule;
  static const tags = _Paths.tags;
  static const payments = _Paths.payments;
  static const profile = _Paths.profile;
}

abstract class _Paths {
  _Paths._();
  static const splash = '/';
  static const login = '/login';
  static const root = '/root';
  static const dashboard = '/dashboard';
  static const users = '/users';
  static const vehicles = '/vehicles';
  static const vehicleTypes = '/vehicle-types';
  static const schedule = '/schedule';
  static const tags = '/tags';
  static const payments = '/payments';
  static const profile = '/profile';
}
