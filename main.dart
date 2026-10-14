import 'dart:io';
import 'dart:math';

class Passenger {
  int id;
  String name;
  String phone;
  String password;
  bool isSuspended = false;

  Passenger(this.id, this.name, this.phone, this.password);

  String get code => 'SRP${id.toString().padLeft(3, '0')}';
}

class Driver {
  int id;
  String name;
  String phone;
  String password;
  String vehicleType;
  String vehicleNumber;
  bool isOnline = true;
  bool isSuspended = false;
  List<int> ratings = [];

  Driver(this.id, this.name, this.phone, this.password, this.vehicleType,
      this.vehicleNumber);

  String get code => 'SRD${id.toString().padLeft(3, '0')}';

  /// Average of all star ratings (0 if the driver has none yet).
  double get averageRating {
    if (ratings.isEmpty) return 0;
    int total = 0;
    for (int stars in ratings) {
      total += stars;
    }
    return total / ratings.length;
  }
}

class Ride {
  int id;
  Passenger passenger;
  Driver driver;
  String pickup;
  String destination;
  String vehicleType;
  double distance;
  double fare;
  String status = waiting;
  int rating = 0; 
  String review = '';

  Ride(this.id, this.passenger, this.driver, this.pickup, this.destination,
      this.vehicleType, this.distance, this.fare);

  String get code => 'SRR${id.toString().padLeft(3, '0')}';
}

const String waiting = 'Awaiting Driver';
const String accepted = 'Accepted';
const String inProgress = 'In Progress';
const String completed = 'Completed';
const String cancelled = 'Cancelled';
const String rejected = 'Rejected';

// The vehicle types a passenger can choose.
const List<String> vehicleTypes = ['Kekeh', 'Taxi', 'Private Vehicle'];

// SYSTEM DATA AND DEMO ACCOUNTS
List<Passenger> passengers = [];
List<Driver> drivers = [];
List<Ride> rides = [];

int nextPassengerId = 1;
int nextDriverId = 1;
int nextRideId = 1;

const String adminUsername = 'admin';
const String adminPassword = 'admin123';

void loadDemoData() {
  drivers.add(Driver(nextDriverId++, 'Mohamed Kamara', '076123456',
      'driver123', 'Kekeh', 'KKE-1023'));
  drivers.add(Driver(nextDriverId++, 'Abdul Sesay', '077234567', 'driver123',
      'Taxi', 'TX-4521'));
  drivers.add(Driver(nextDriverId++, 'Ibrahim Bangura', '078345678',
      'driver123', 'Private Vehicle', 'PV-7821'));
  passengers.add(
      Passenger(nextPassengerId++, 'Fatmata Conteh', '077111222', 'pass123'));
}

void main() {
  loadDemoData();
  mainMenu();
}

// MAIN MENU, REGISTRATION AND LOGIN
void mainMenu() {
  while (true) {
    printHeader();
    print('1. Passenger Login');
    print('2. Driver Login');
    print('3. Administrator Login');
    print('4. Register as a Passenger');
    print('5. Register as a Driver');
    print('6. View Demo Accounts');
    print('0. Exit');

    String choice = getInput('\nSelect an option: ');

    switch (choice) {
      case '1':
        passengerLogin();
        break;
      case '2':
        driverLogin();
        break;
      case '3':
        adminLogin();
        break;
      case '4':
        registerPassenger();
        break;
      case '5':
        registerDriver();
        break;
      case '6':
        showDemoAccounts();
        break;
      case '0':
        print('\nThank you for using SaloneRide. Safe travels in Salone!');
        return;
      default:
        printError('Invalid option. Please choose a number from the menu.');
    }
  }
}

void registerPassenger() {
  printSection('PASSENGER REGISTRATION');

  String name = getInput('Full name       : ');
  String phone = getInput('Phone number    : ');
  String password = getInput('Create password : ');

  if (!isValidName(name) || !isValidPhone(phone) ||
      !isValidPassword(password)) {
    return; // the check already printed the reason
  }

  for (Passenger p in passengers) {
    if (p.phone == phone) {
      printError('An account already exists with this phone number.');
      return;
    }
  }

  Passenger passenger = Passenger(nextPassengerId++, name, phone, password);
  passengers.add(passenger);
  printSuccess('Account created! Your passenger ID is ${passenger.code}.');
}

void registerDriver() {
  printSection('DRIVER REGISTRATION');

  String name = getInput('Full name       : ');
  String phone = getInput('Phone number    : ');
  String password = getInput('Create password : ');

  if (!isValidName(name) || !isValidPhone(phone) ||
      !isValidPassword(password)) {
    return;
  }

  for (Driver d in drivers) {
    if (d.phone == phone) {
      printError('A driver account already exists with this phone number.');
      return;
    }
  }

  String? vehicleType = chooseVehicleType();
  if (vehicleType == null) return;

  String vehicleNumber = getInput('Vehicle number  : ').toUpperCase();
  if (vehicleNumber.length < 3) {
    printError('Vehicle number is too short, e.g. AKE-123.');
    return;
  }

  Driver driver = Driver(nextDriverId++, name, phone, password, vehicleType,
      vehicleNumber);
  drivers.add(driver);
  printSuccess('Registration complete! Your driver ID is ${driver.code}.');
}

void passengerLogin() {
  printSection('PASSENGER LOGIN');
  String phone = getInput('Phone number : ');
  String password = getInput('Password     : ');

  for (Passenger p in passengers) {
    if (p.phone == phone && p.password == password) {
      if (p.isSuspended) {
        printError('This account has been suspended. Contact the admin.');
        return;
      }
      printSuccess('Welcome back, ${p.name}!');
      passengerMenu(p);
      return;
    }
  }
  printError('Incorrect phone number or password.');
}

void driverLogin() {
  printSection('DRIVER LOGIN');
  String phone = getInput('Phone number : ');
  String password = getInput('Password     : ');

  for (Driver d in drivers) {
    if (d.phone == phone && d.password == password) {
      if (d.isSuspended) {
        printError('This account has been suspended. Contact the admin.');
        return;
      }
      printSuccess('Welcome back, ${d.name}!');
      driverMenu(d);
      return;
    }
  }
  printError('Incorrect phone number or password.');
}

void adminLogin() {
  printSection('ADMINISTRATOR LOGIN');
  String username = getInput('Username : ');
  String password = getInput('Password : ');

  if (username == adminUsername && password == adminPassword) {
    printSuccess('Welcome, Administrator!');
    adminMenu();
  } else {
    printError('Incorrect username or password.');
  }
}

void showDemoAccounts() {
  printSection('DEMO ACCOUNTS');
  print('Passenger        : 077111222 / pass123');
  print('Driver (Kekeh)   : 076123456 / driver123');
  print('Driver (Taxi)    : 077234567 / driver123');
  print('Driver (Private) : 078345678 / driver123');
  print('Administrator    : admin / admin123');
}

// PART 4: PASSENGER FEATURES
void passengerMenu(Passenger passenger) {
  while (true) {
    printSection('PASSENGER DASHBOARD - ${passenger.name}');
    print('1. Request a Ride');
    print('2. View Current Ride');
    print('3. Cancel Current Ride');
    print('4. Rate a Completed Trip');
    print('5. View My Trips');
    print('6. View My Profile');
    print('0. Logout');

    String choice = getInput('\nSelect an option: ');

    switch (choice) {
      case '1':
        requestRide(passenger);
        break;
      case '2':
        viewCurrentRide(passenger);
        break;
      case '3':
        cancelRide(passenger);
        break;
      case '4':
        rateTrip(passenger);
        break;
      case '5':
        viewPassengerTrips(passenger);
        break;
      case '6':
        viewPassengerProfile(passenger);
        break;
      case '0':
        printSuccess('You have been logged out.');
        return;
      default:
        printError('Invalid option.');
    }
  }
}

void requestRide(Passenger passenger) {
  printSection('REQUEST A RIDE');

  if (findActiveRide(passenger) != null) {
    printError('You already have an active ride. Finish or cancel it first.');
    return;
  }

  String pickup = getInput('Pickup location : ');
  String destination = getInput('Destination     : ');

  if (pickup.isEmpty || destination.isEmpty) {
    printError('Pickup and destination are required.');
    return;
  }
  if (pickup.toLowerCase() == destination.toLowerCase()) {
    printError('Pickup and destination cannot be the same.');
    return;
  }

  
  double distance = generateDistance();
  print('\nEstimated distance: ${distance.toStringAsFixed(1)} km\n');
  print('No. | Vehicle Type     | Estimated Fare | Drivers Free');
  print('----+------------------+----------------+-------------');
  for (int i = 0; i < vehicleTypes.length; i++) {
    String type = vehicleTypes[i];
    double fare = calculateFare(type, distance);
    int free = countFreeDrivers(type);
    print('${i + 1}.  | ${type.padRight(16)} | '
        '${money(fare).padRight(14)} | $free');
  }

  String? vehicleType = chooseVehicleType();
  if (vehicleType == null) return;

  Driver? driver = findAvailableDriver(vehicleType);
  if (driver == null) {
    printError('Sorry, no $vehicleType driver is available right now.');
    return;
  }

  double fare = calculateFare(vehicleType, distance);
  if (!confirm('Request a $vehicleType for ${money(fare)}?')) {
    print('Ride request was not sent.');
    return;
  }

  Ride ride = Ride(nextRideId++, passenger, driver, pickup, destination,
      vehicleType, distance, fare);
  rides.add(ride);

  printSuccess('Driver found! Your request was sent to ${driver.name}.');
  printRide(ride);
}

void viewCurrentRide(Passenger passenger) {
  printSection('CURRENT RIDE');
  Ride? ride = findActiveRide(passenger);
  if (ride == null) {
    print('You do not have an active ride.');
    return;
  }
  printRide(ride);
}

void cancelRide(Passenger passenger) {
  printSection('CANCEL RIDE');
  Ride? ride = findActiveRide(passenger);
  if (ride == null) {
    print('You do not have an active ride to cancel.');
    return;
  }
  if (ride.status == inProgress) {
    printError('The trip has already started, so it cannot be cancelled.');
    return;
  }
  printRide(ride);
  if (confirm('Cancel ride ${ride.code}?')) {
    ride.status = cancelled;
    printSuccess('Ride ${ride.code} has been cancelled.');
  }
}

void rateTrip(Passenger passenger) {
  printSection('RATE A COMPLETED TRIP');

  List<Ride> unrated = rides
      .where((r) =>
          r.passenger == passenger && r.status == completed && r.rating == 0)
      .toList();

  if (unrated.isEmpty) {
    print('You have no completed trips waiting for a rating.');
    return;
  }

  for (int i = 0; i < unrated.length; i++) {
    Ride r = unrated[i];
    print('${i + 1}. ${r.code}  ${r.pickup} -> ${r.destination}  '
        '(driver: ${r.driver.name})');
  }

  int? choice = int.tryParse(getInput('\nSelect a trip: '));
  if (choice == null || choice < 1 || choice > unrated.length) {
    printError('Invalid choice.');
    return;
  }

  int? stars = int.tryParse(getInput('Rating (1-5 stars): '));
  if (stars == null || stars < 1 || stars > 5) {
    printError('Rating must be a number from 1 to 5.');
    return;
  }

  Ride ride = unrated[choice - 1];
  ride.rating = stars;
  ride.review = getInput('Short review (optional): ');
  ride.driver.ratings.add(stars);
  printSuccess('Thank you! You gave ${ride.driver.name} $stars/5.');
}

void viewPassengerTrips(Passenger passenger) {
  printSection('MY TRIPS');

  List<Ride> myRides = rides.where((r) => r.passenger == passenger).toList();
  if (myRides.isEmpty) {
    print('You have not requested any rides yet.');
    return;
  }

  double spent = 0;
  for (Ride ride in myRides) {
    printRide(ride);
    if (ride.status == completed) spent += ride.fare;
  }
  print('\nTotal rides : ${myRides.length}');
  print('Total spent : ${money(spent)}');
}

void viewPassengerProfile(Passenger passenger) {
  printSection('MY PROFILE');
  print('Passenger ID : ${passenger.code}');
  print('Name         : ${passenger.name}');
  print('Phone        : ${passenger.phone}');
  int total = rides.where((r) => r.passenger == passenger).length;
  print('Total rides  : $total');
}
//  DRIVER FEATURES

void driverMenu(Driver driver) {
  while (true) {
    printSection('DRIVER DASHBOARD - ${driver.name}');
    print('Status: ${driver.isOnline ? 'Online' : 'Offline'}\n');
    print('1. View Ride Requests');
    print('2. Manage Active Trip');
    print('3. Go ${driver.isOnline ? 'Offline' : 'Online'}');
    print('4. Trip History & Earnings');
    print('5. View My Profile');
    print('0. Logout');

    String choice = getInput('\nSelect an option: ');

    switch (choice) {
      case '1':
        viewRideRequests(driver);
        break;
      case '2':
        manageActiveTrip(driver);
        break;
      case '3':
        changeAvailability(driver);
        break;
      case '4':
        viewDriverTrips(driver);
        break;
      case '5':
        viewDriverProfile(driver);
        break;
      case '0':
        printSuccess('You have been logged out.');
        return;
      default:
        printError('Invalid option.');
    }
  }
}

void viewRideRequests(Driver driver) {
  printSection('RIDE REQUESTS');

  List<Ride> requests =
      rides.where((r) => r.driver == driver && r.status == waiting).toList();

  if (requests.isEmpty) {
    print('You have no new ride requests.');
    return;
  }

  for (Ride ride in requests) {
    printRide(ride);
    if (confirm('Accept this ride?')) {
      ride.status = accepted;
      printSuccess('Ride accepted. Use "Manage Active Trip" at pickup.');
    } else {
      ride.status = rejected;
      print('Ride rejected. The passenger can request again.');
    }
  }
}

void manageActiveTrip(Driver driver) {
  printSection('ACTIVE TRIP');

  Ride? ride;
  for (Ride r in rides) {
    if (r.driver == driver && (r.status == accepted || r.status == inProgress)) {
      ride = r;
    }
  }

  if (ride == null) {
    print('You have no active trip. Accept a ride request first.');
    return;
  }

  printRide(ride);

  if (ride.status == accepted) {
    if (confirm('Passenger picked up? Start the trip now?')) {
      ride.status = inProgress;
      printSuccess('Trip started. Drive safely!');
    }
  } else {
    if (confirm('Arrived at the destination? Complete the trip?')) {
      ride.status = completed;
      printSuccess('Trip completed! ${money(ride.fare)} added to earnings.');
    }
  }
}

void changeAvailability(Driver driver) {
  if (driver.isOnline && isDriverBusy(driver)) {
    printError('You cannot go offline while you have an active ride.');
    return;
  }
  driver.isOnline = !driver.isOnline;
  printSuccess('You are now ${driver.isOnline ? 'ONLINE' : 'OFFLINE'}.');
}

void viewDriverTrips(Driver driver) {
  printSection('TRIP HISTORY & EARNINGS');

  List<Ride> done =
      rides.where((r) => r.driver == driver && r.status == completed).toList();

  if (done.isEmpty) {
    print('You have not completed any trips yet.');
    return;
  }

  double earnings = 0;
  for (Ride ride in done) {
    print('${ride.code}  ${ride.passenger.name}  '
        '${ride.pickup} -> ${ride.destination}  ${money(ride.fare)}');
    earnings += ride.fare;
  }

  print('\nCompleted trips : ${done.length}');
  print('Total earnings  : ${money(earnings)}');
  print('Average rating  : ${driver.averageRating.toStringAsFixed(1)} / 5');
}

void viewDriverProfile(Driver driver) {
  printSection('MY PROFILE');
  print('Driver ID      : ${driver.code}');
  print('Name           : ${driver.name}');
  print('Phone          : ${driver.phone}');
  print('Vehicle        : ${driver.vehicleType} (${driver.vehicleNumber})');
  print('Average rating : ${driver.averageRating.toStringAsFixed(1)} / 5');
}

// ADMINISTRATOR FEATURES
void adminMenu() {
  while (true) {
    printSection('ADMINISTRATOR DASHBOARD');
    print('1. View All Passengers');
    print('2. View All Drivers');
    print('3. Monitor All Rides');
    print('4. Suspend or Reactivate an Account');
    print('0. Logout');

    String choice = getInput('\nSelect an option: ');

    switch (choice) {
      case '1':
        viewAllPassengers();
        break;
      case '2':
        viewAllDrivers();
        break;
      case '3':
        viewAllRides();
        break;
      case '4':
        suspendOrReactivate();
        break;
      case '0':
        printSuccess('You have been logged out.');
        return;
      default:
        printError('Invalid option.');
    }
  }
}

void viewAllPassengers() {
  printSection('ALL PASSENGERS');
  for (Passenger p in passengers) {
    String status = p.isSuspended ? 'Suspended' : 'Active';
    print('${p.code}  ${p.name.padRight(18)} ${p.phone}  $status');
  }
}

void viewAllDrivers() {
  printSection('ALL DRIVERS');
  for (Driver d in drivers) {
    String status =
        d.isSuspended ? 'Suspended' : (d.isOnline ? 'Online' : 'Offline');
    print('${d.code}  ${d.name.padRight(18)} '
        '${d.vehicleType.padRight(16)} ${d.vehicleNumber.padRight(9)} $status');
  }
}

void viewAllRides() {
  printSection('ALL RIDES');
  if (rides.isEmpty) {
    print('No rides have been requested yet.');
    return;
  }
  for (Ride r in rides) {
    print('${r.code}  ${r.passenger.name.padRight(16)} '
        '${r.driver.name.padRight(16)} ${money(r.fare).padRight(11)} '
        '${r.status}');
  }
}

void suspendOrReactivate() {
  printSection('SUSPEND OR REACTIVATE');
  String code = getInput('Enter account ID (e.g. SRP001 or SRD002): ')
      .toUpperCase();

  for (Passenger p in passengers) {
    if (p.code == code) {
      if (!p.isSuspended && findActiveRide(p) != null) {
        printError('This passenger has an active ride. Try again later.');
        return;
      }
      p.isSuspended = !p.isSuspended;
      printSuccess('${p.name} is now ${p.isSuspended ? 'suspended' : 'active'}.');
      return;
    }
  }

  for (Driver d in drivers) {
    if (d.code == code) {
      if (!d.isSuspended && isDriverBusy(d)) {
        printError('This driver has an active ride. Try again later.');
        return;
      }
      d.isSuspended = !d.isSuspended;
      printSuccess('${d.name} is now ${d.isSuspended ? 'suspended' : 'active'}.');
      return;
    }
  }

  printError('No account was found with ID $code.');
}

// RULES - CHECKING INPUT, FARES AND FINDING A DRIVER
bool isValidName(String name) {
  if (name.length < 3) {
    printError('Name must be at least 3 characters.');
    return false;
  }
  return true;
}

bool isValidPhone(String phone) {
  if (!RegExp(r'^0\d{8}$').hasMatch(phone)) {
    printError('Enter a valid Sierra Leone phone number, e.g. 076123456.');
    return false;
  }
  return true;
}

bool isValidPassword(String password) {
  if (password.length < 6) {
    printError('Password must be at least 6 characters.');
    return false;
  }
  return true;
}

double calculateFare(String vehicleType, double distance) {
  double baseFare;
  double ratePerKm;

  switch (vehicleType) {
    case 'Kekeh':
      baseFare = 10;
      ratePerKm = 8;
      break;
    case 'Taxi':
      baseFare = 15;
      ratePerKm = 10;
      break;
    default: // Private Vehicle
      baseFare = 20;
      ratePerKm = 15;
  }

  return (baseFare + distance * ratePerKm).roundToDouble();
}

double generateDistance() {
  return 2 + Random().nextDouble() * 8;
}

bool isDriverBusy(Driver driver) {
  for (Ride r in rides) {
    if (r.driver == driver &&
        (r.status == waiting || r.status == accepted || r.status == inProgress)) {
      return true;
    }
  }
  return false;
}

bool isDriverFree(Driver driver) =>
    driver.isOnline && !driver.isSuspended && !isDriverBusy(driver);

Driver? findAvailableDriver(String vehicleType) {
  for (Driver d in drivers) {
    if (d.vehicleType == vehicleType && isDriverFree(d)) {
      return d;
    }
  }
  return null;
}

int countFreeDrivers(String vehicleType) {
  int count = 0;
  for (Driver d in drivers) {
    if (d.vehicleType == vehicleType && isDriverFree(d)) count++;
  }
  return count;
}

// The passenger's ride that is still waiting, accepted or in progress.
Ride? findActiveRide(Passenger passenger) {
  for (Ride r in rides) {
    if (r.passenger == passenger &&
        (r.status == waiting || r.status == accepted || r.status == inProgress)) {
      return r;
    }
  }
  return null;
}

// SMALL HELPERS FOR INPUT AND OUTPUT
String getInput(String message) {
  stdout.write(message);
  return stdin.readLineSync()?.trim() ?? '';
}

bool confirm(String question) {
  String answer = getInput('$question (Y/N): ');
  return answer.toUpperCase() == 'Y';
}

String? chooseVehicleType() {
  print('\nVehicle types: 1. Kekeh   2. Taxi   3. Private Vehicle');
  int? choice = int.tryParse(getInput('Select vehicle type (1-3): '));
  if (choice == null || choice < 1 || choice > 3) {
    printError('Invalid vehicle type.');
    return null;
  }
  return vehicleTypes[choice - 1];
}

void printRide(Ride ride) {
  print('----------------------------------------------------');
  print('Ride ID     : ${ride.code}');
  print('Status      : ${ride.status}');
  print('Passenger   : ${ride.passenger.name} (${ride.passenger.phone})');
  print('Driver      : ${ride.driver.name} (${ride.driver.phone})');
  print('Vehicle     : ${ride.vehicleType} (${ride.driver.vehicleNumber})');
  print('Driver rating: ${ride.driver.averageRating.toStringAsFixed(1)} / 5');
  print('From        : ${ride.pickup}');
  print('To          : ${ride.destination}');
  print('Distance    : ${ride.distance.toStringAsFixed(1)} km');
  print('Fare        : ${money(ride.fare)}');
  print('----------------------------------------------------');
}

String money(double amount) => 'SLE ${amount.toStringAsFixed(2)}';

void printHeader() {
  print('\n==================================================');
  print('                   SALONERIDE');
  print('      Campus-Based Ride-Hailing System');
  print('==================================================');
}

void printSection(String title) {
  print('\n--------------------------------------------------');
  print('  $title');
  print('--------------------------------------------------');
}

void printSuccess(String message) => print('\n[SUCCESS] $message');

void printError(String message) => print('\n[ERROR] $message');
